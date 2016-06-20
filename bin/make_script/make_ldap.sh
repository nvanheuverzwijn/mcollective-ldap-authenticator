#!/bin/bash

cd ldap.schema

TEMPLATE=mcollective.schema.template
TARGET=mcollective.schema

#
# Replacement variable
#
OID=$(cat "oid")
OID_REPLACEMENT="{oid}"

echo "Generating 'ldap.schema/$TARGET' by replacing '$OID_REPLACEMENT' with '$OID'" >&2
sed "s/$OID_REPLACEMENT/$OID/g" $TEMPLATE > $TARGET
