#!/bin/sh

# Copyright 2022 Hewlett Packard Enterprise Development LP

if [ $# -lt 2 ]; then
    echo >&2 "usage: ${0} KEYSTORE CERT..."
    exit 2
fi

keystore="$1"
shift

if [ ! -f "$keystore" ]; then
    echo >&2 "Initializing trust store from /usr/lib/jvm/java-1.8.0/jre/lib/security/cacerts"
    # Start with default JRE trust store
    cp /usr/lib/jvm/java-1.8.0/jre/lib/security/cacerts "$keystore"
    # Make sure it is writable
    chmod -v u=rw,go=r "$keystore"
fi

# Add every cert specified on the command line
while [ $# -gt 0 ]; do
    cert="$1"
    echo >&2 "Importing $cert"
    keytool -importcert -keystore "$keystore" -storepass changeit -noprompt \
        -file "$cert" -alias "cray-hpe-$(basename $cert)" >&2
    shift
done

# List all certs in trust-store
keytool -list -keystore "$keystore" -storepass changeit -noprompt

