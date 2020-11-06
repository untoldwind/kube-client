FROM ubuntu:xenial

RUN apt-get update \
    && apt-get install -y apt-transport-https gnupg2 curl git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && curl https://baltocdn.com/helm/signing.asc | apt-key add - \
    && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list \
    && echo "deb https://baltocdn.com/helm/stable/debian/ all main" > /etc/apt/sources.list.d/helm-stable-debian.list \
    && apt-get update \
    && apt-get install kubectl helm \
    && rm -rf /var/lib/apt/lists/*

ENV HOME=/home

RUN cd "$(mktemp -d)" && \
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/krew.tar.gz" && \
  tar zxvf krew.tar.gz && \
  KREW=./krew-"$(uname | tr '[:upper:]' '[:lower:]')_$(uname -m | sed -e 's/x86_64/amd64/' -e 's/arm.*$/arm/')" && \
  "$KREW" install krew

ENV PATH=$PATH:/home/.krew/bin

RUN kubectl krew install oidc-login && \
    chmod 755 -R /home/.krew

VOLUME [ "/project", "/root/.kube" ]

WORKDIR /project

