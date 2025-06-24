#
# MIT License
#
# (C) Copyright [2021-2022] Hewlett Packard Enterprise Development LP
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
FROM debian:12-slim

USER root

RUN echo "--- Method 1: Displaying APT source configuration file ---" && \
    echo "--- Contents of /etc/apt/sources.list.d/debian.sources: ---" && \
    cat /etc/apt/sources.list.d/debian.sources && \
    echo

RUN echo "--- Method 2: Extracting URLs from verbose apt-get update ---" && \
    apt-get update -y -o Debug::Acquire::http=true 2>&1 | grep 'Get:' | awk '{print $2}' | cut -d'/' -f3 | sort -u

RUN echo "--- End of diagnostics. Failing build intentionally. ---" && \
    exit 1