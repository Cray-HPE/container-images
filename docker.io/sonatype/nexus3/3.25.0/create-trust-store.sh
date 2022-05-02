#!/bin/sh
#
# MIT License
#
# (C) Copyright 2022 Hewlett Packard Enterprise Development LP
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
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

