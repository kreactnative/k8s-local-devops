FROM docker:23.0.3-dind-alpine3.17
ARG KUBE_VERSION='1.26.4'
ARG HELM_VERSION='3.11.3'
ARG TARGETOS='linux'
ARG TARGETARCH='amd64'

RUN apk -U upgrade \
    && apk add --no-cache ca-certificates bash git openssh curl gettext jq wget \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/v${KUBE_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl -O /usr/local/bin/kubectl \
    && wget -q https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz -O - | tar -xzO ${TARGETOS}-${TARGETARCH}/helm > /usr/local/bin/helm \
    && chmod +x /usr/local/bin/helm /usr/local/bin/kubectl \
    && mkdir /config \
    && chmod g+rwx /config /root \
    && helm repo add "stable" "https://charts.helm.sh/stable" --force-update \
    && kubectl version --client \
    && helm version


WORKDIR /config

CMD bash
