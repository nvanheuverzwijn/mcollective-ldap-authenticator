#!/bin/bash

cd ldap.schema

TEMPLATE=action-policy.schema.template
TARGET=action-policy.schema

#
# Replacement variable
#
OID=$(cat "oid")
OID_REPLACEMENT="{oid}"

echo "Generating 'ldap.schema/$TARGET' by replacing '$OID_REPLACEMENT' with '$OID'" >&2
sed "s/$OID_REPLACEMENT/$OID/g" $TEMPLATE > $TARGET
