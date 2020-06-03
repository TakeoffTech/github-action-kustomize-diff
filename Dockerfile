FROM alpine:3

RUN apk add --no-cache \
  bash \
  git \
  && rm -rf /var/cache/apk/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.6.1/kustomize_v3.6.1_linux_amd64.tar.gz \
  | tar xz -C /usr/local/bin 

COPY kustdiff /kustdiff

ENTRYPOINT ["/kustdiff"]
