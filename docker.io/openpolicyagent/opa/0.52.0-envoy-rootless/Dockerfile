#
# MIT License
#
# (C) Copyright [2023,2024] Hewlett Packard Enterprise Development LP
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
FROM golang:1.20.3 as builder
RUN git clone https://github.com/open-policy-agent/opa-envoy-plugin /opt/opa-envoy-plugin\
  && cd /opt/opa-envoy-plugin\
  && git checkout v0.52.0-envoy\
  && GOOS=linux WASM_ENABLED=0 CGO_ENABLED=0 make

FROM cgr.dev/chainguard/glibc-dynamic:latest
USER 1000:1000
COPY --from=builder /opt/opa-envoy-plugin/opa_envoy_linux_amd64 /app/opa_envoy_linux_amd64
WORKDIR /app
ENTRYPOINT ["./opa_envoy_linux_amd64"]
CMD ["run"]
