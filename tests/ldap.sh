#!/bin/bash

cd "${0%/*}"
RC=0

/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/allow-root-rpcutil-get_fact.ldif > /dev/null
echo 'TEST: action policy >allow cert=root rpcutil get_fact< should be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'FAIL'
  RC=1
else
  echo 'SUCCESS'
fi
tac ./fixture/allow-root-rpcutil-get_fact.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/disallow-root-rpcutil-get_fact.ldif > /dev/null
echo 'TEST: action policy >deny cert=root rpcutil get_fact< should not be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'SUCCESS'
else
  echo 'FAIL'
  RC=1
fi
tac ./fixture/disallow-root-rpcutil-get_fact.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/allow-root-rpcutil-star.ldif > /dev/null
echo 'TEST: action policy >allow cert=root rpcutil *< should be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'FAIL'
  RC=1
else
  echo 'SUCCESS'
fi
tac ./fixture/allow-root-rpcutil-star.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/disallow-root-rpcutil-star.ldif > /dev/null
echo 'TEST: action policy >deny cert=root rpcutil *< should not be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'SUCCESS'
else
  echo 'FAIL'
  RC=1
fi
tac ./fixture/disallow-root-rpcutil-star.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/allow-root-star-star.ldif > /dev/null
echo 'TEST: action policy >allow cert=root * *< should be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'FAIL'
  RC=1
else
  echo 'SUCCESS'
fi
tac ./fixture/allow-root-star-star.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/disallow-root-star-star.ldif > /dev/null
echo 'TEST: action policy >deny cert=root * *< should not be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'SUCCESS'
else
  echo 'FAIL'
  RC=1
fi
tac ./fixture/disallow-root-star-star.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/allow-star-star-star.ldif > /dev/null
echo 'TEST: action policy >allow * * *< should be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'FAIL'
  RC=1
else
  echo 'SUCCESS'
fi
tac ./fixture/allow-star-star-star.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


/usr/bin/ldapadd -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 -f ./fixture/disallow-star-star-star.ldif > /dev/null
echo 'TEST: action policy >deny * * *< should not be allowed'
mco rpc rpcutil get_fact fact=os > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo 'SUCCESS'
else
  echo 'FAIL'
  RC=1
fi
tac ./fixture/disallow-star-star-star.ldif | grep dn | cut -f 2 -d " " | xargs -I{} /usr/bin/ldapdelete -x -D 'cn=admin,dc=example,dc=com' -w asdF1234 {}


exit $RC
