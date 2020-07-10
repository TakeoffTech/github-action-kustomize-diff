FROM alpine:3 AS build-image

RUN apk add --no-cache \
  curl \
  bash \
  git \
  && rm -rf /var/cache/apk/*

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN curl -sL https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.6.1/kustomize_v3.6.1_linux_amd64.tar.gz \
  | tar xz -C /usr/local/bin 

COPY kustdiff /kustdiff

ENTRYPOINT ["/kustdiff"]

FROM build-image as testEnv
COPY ./test /test
RUN apk add --no-cache coreutils bats && \
    cp /test/mock.sh /usr/local/bin/kustomize && \
    cp /test/mock.sh /usr/local/bin/git && \
    /test/test.bats

FROM build-image