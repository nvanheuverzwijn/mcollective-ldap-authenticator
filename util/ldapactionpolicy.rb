require 'net/ldap'

module MCollective
  module Util
    class LdapActionPolicy
      attr_accessor :config, :allow_unconfigured, :treebase, :username, :password, :host, :port, :configdir, :agent, :caller, :action

      def self.authorize(request)
        LdapActionPolicy.new(request).authorize_request
      end

      def initialize(request)
        @config = Config.instance
        @agent = request.agent
        @caller = request.caller
        @action = request.action
        @allow_unconfigured = !!(config.pluginconf.fetch('ldapactionpolicy.allow_unconfigured', 'n') =~ /^1|y/i)
        @configdir = @config.configdir
        @treebase=config.pluginconf.fetch('ldapactionpolicy.treebase', '')
        @username=config.pluginconf.fetch('ldapactionpolicy.username', '')
        @password=config.pluginconf.fetch('ldapactionpolicy.password', '')
        @host=config.pluginconf.fetch('ldapactionpolicy.host', '127.0.0.1')
        @port=config.pluginconf.fetch('ldapactionpolicy.port', 389)
      end

      def authorize_request
        # A policy file exists
        Log.debug('Parsing ldap policy for %s' % [@agent])
        allow = @allow_unconfigured
        ldap = Net::LDAP.new :host => @host,
          :port => @port,
          :auth => {
                :method => :simple,
                :username => @username,
                :password => @password
          }

        # does not seem to work ?
        if !ldap.bind
          Log.warn("Cannot connect to ldap. Wrong host ? Wrong username ? Wrong password ?")
          return false
        end

        # Maybe filter diretly with the @caller variable ?
        filter = Net::LDAP::Filter.eq( "mcollectiveAgent", @agent )
        ldap.search( :base => @treebase, :filter => filter, :return_result => false ) do |entry|
          allow = false
          line = ( entry.mcollectiveallow[0] == 'TRUE' ? 'allow' : 'deny' ) + "\t" +
                 entry.mcollectivecaller.join(" ") + "\t" +
                 entry.mcollectiveaction.join(" ") + "\t" +
                 entry.mcollectivefact.join(" ") + "\t" +
                 entry.mcollectiveclass.join(" ")
          Log.debug("Generated line '%s'" % line)
          if line =~ /^(allow|deny)\t+(.+?)\t+(.+?)\t+(.+?)(\t+(.+?))*$/
            if check_policy($2, $3, $4, $6)
              if $1 == 'allow'
                return true
              else
                deny("Denying based on explicit 'deny' policy rule in ldap: %s" % line)
              end
            end
          else
            Log.warn("Cannot parse ldap policy line: %s" % line)
          end
        end

        allow || deny("Denying based on default ldap policy")
      end

      # Check if a request made by a caller matches the state defined in the policy
      def check_policy(rpccaller, actions, facts, classes)
        # If we have a wildcard caller or the caller matches our policy line
        # then continue else skip this policy line\
        if (rpccaller != '*') && (! rpccaller || ! rpccaller.split.include?(@caller))
          return false
        end

        # If we have a wildcard actions list or the request action is in the list
        # of actions in the policy line continue, else skip this policy line
        if (actions != '*') && !(actions.split.include?(@action))
          return false
        end

        unless classes
          return parse_compound(facts)
        else
          return parse_facts(facts) && parse_classes(classes)
        end
      end

      def parse_facts(facts)
        return true if facts == '*'

        if is_compound?(facts)
          return parse_compound(facts)
        else
          facts.split.each do |fact|
            return false unless lookup_fact(fact)
          end
        end

        true
      end

      def parse_classes(classes)
        return true if classes == '*'

        if is_compound?(classes)
          return parse_compound(classes)
        else
          classes.split.each do |klass|
            return false unless lookup_class(klass)
          end
        end

        true
      end

      def lookup_fact(fact)
        if fact =~ /(.+)(<|>|=|<=|>=)(.+)/
          lv = $1
          sym = $2
          rv = $3

          sym = '==' if sym == '='
          return eval("'#{Util.get_fact(lv)}'#{sym}'#{rv}'")
        else
          Log.warn("Class found where fact was expected")
          return false
        end
      end

      def lookup_class(klass)
        if klass =~ /(.+)(<|>|=|<=|>=)(.+)/
          Log.warn("Fact found where class was expected")
          return false
        else
          return Util.has_cf_class?(klass)
        end
      end

      def lookup(token)
        if token =~  /(.+)(<|>|=|<=|>=)(.+)/
          return lookup_fact(token)
        else
          return lookup_class(token)
        end
      end

      # Evalute a compound statement and return its truth value
      def eval_statement(statement)
        token_type = statement.keys.first
        token_value = statement.values.first

        return token_value if (token_type != 'statement' && token_type != 'fstatement')

        if token_type == 'statement'
            return lookup(token_value)
        elsif token_type == 'fstatement'
          begin
            return Matcher.eval_compound_fstatement(token_value)
          rescue => e
            Log.warn("Could not call Data function in policy file: #{e}")
            return false
          end
        end
      end

      def is_compound?(list)
        list.split.each do |token|
          if token =~ /^!|^not$|^or$|^and$|\(.+\)/
            return true
          end
        end

        false
      end

      def parse_compound(list)
        stack = Matcher.create_compound_callstack(list)

        begin
          stack.map!{ |item| eval_statement(item) }
        rescue => e
          Log.debug(e.to_s)
          return false
        end

        eval(stack.join(' '))
      end

      def deny(logline)
        Log.debug(logline)

        raise(RPCAborted, 'You are not authorized to call this agent or action.')
      end
    end
  end
end
