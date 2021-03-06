FROM argoproj/argocd:v1.8.7

##
# Install mozilla sops
##
ARG SOPS_VERSION=3.6.0

USER root

ADD https://aka.ms/InstallAzureCLIDeb /tmp/InstallAzureCLIDeb
RUN bash /tmp/InstallAzureCLIDeb

ADD https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops_${SOPS_VERSION}_amd64.deb /tmp/sops_amd64.deb
RUN dpkg -i /tmp/sops_amd64.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
USER argocd

##
# Install helm-secrets plugin
##
ENV HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/"
ARG SECRETS_PLUGIN_VERSION="2.0.2"

RUN helm plugin install https://github.com/zendesk/helm-secrets --version ${SECRETS_PLUGIN_VERSION} \
    && sed -i 's/rm -v/rm/g' ${HELM_PLUGINS}/helm-secrets/secrets.sh

##
# Install helm-git plugin
##
ARG GIT_PLUGIN_VERSION="0.8.1"
RUN helm plugin install https://github.com/aslafy-z/helm-git --version ${GIT_PLUGIN_VERSION}

USER root
RUN mv /usr/local/bin/helm /usr/local/bin/helm-original
COPY bin/helm-wrapper.sh /usr/local/bin/helm
USER argocd
