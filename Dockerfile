FROM sphinxdoc/sphinx-latexpdf:8.2.3
LABEL maintainer="Jens Frey <jens.frey@coffeecrew.org>" Version="2025-10-16"

ARG DEBIAN_FRONTEND=noninteractive
ARG DRAWIO_VER=28.2.5

RUN apt-get update && \
    apt-get -y install git gcc g++ python3-dev wget openjdk-17-jdk-headless plantuml docutils nginx

WORKDIR /usr/share/plantuml/
RUN rm -rf plantuml.jar && \
     wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate && \
     mkdir -p /usr/local/plantuml/ && ln -sf /usr/share/plantuml/plantuml.jar /usr/local/plantuml/plantuml.jar


# Install required dependencies for draw.io
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget curl xvfb \
    libgtk-3-0 libnss3 libxss1 libasound2 libgbm1 libx11-xcb1 \
    libxcomposite1 libxrandr2 libxdamage1 libxi6 libxtst6 libglib2.0-0 \
    libxext6 libxfixes3 libdrm2 libxshmfence1 libpangocairo-1.0-0 \
    fonts-liberation libgl1 \
    libsecret-1-0 libappindicator3-1 libnotify4 \
 && rm -rf /var/lib/apt/lists/*


# Download and install draw.io for correct architecture
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        URL="https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VER}/drawio-amd64-${DRAWIO_VER}.deb"; \
    elif [ "$ARCH" = "arm64" ]; then \
        URL="https://github.com/jgraph/drawio-desktop/releases/download/v${DRAWIO_VER}/drawio-arm64-${DRAWIO_VER}.deb"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget -O /tmp/drawio.deb "$URL" && \
    apt-get install -y /tmp/drawio.deb && \
    rm /tmp/drawio.deb

# Headless wrapper
RUN printf '%s\n' \
  '#!/bin/sh' \
  'exec xvfb-run -a -s "-screen 0 1920x1080x24" drawio --disable-gpu --no-sandbox "$@"' \
  > /usr/local/bin/drawio-headless && chmod +x /usr/local/bin/drawio-headless


WORKDIR /docs
ADD requirements.txt /docs
RUN pip install --upgrade pip && pip3 install -r requirements.txt

ADD default.template /etc/nginx/templates/default.template

WORKDIR /workspaces

COPY .bashrc /root/.bashrc
COPY topydo.conf /etc/topydo.conf

ENV LC_ALL=C
ENV DRAWIO_BINARY=/usr/local/bin/drawio-headless