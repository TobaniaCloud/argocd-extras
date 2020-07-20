FROM argoproj/argocd:v1.6.1

ARG SOPS_VERSION=3.6.0

USER root
ADD https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb /tmp/sops_amd64.deb
RUN dpkg -i /tmp/sops_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER argocd

ARG SECRETS_PLUGIN_VERSION="2.0.2"

RUN helm plugin install https://github.com/zendesk/helm-secrets --version ${SECRETS_PLUGIN_VERSION}

ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
