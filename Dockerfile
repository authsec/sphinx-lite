FROM sphinxdoc/sphinx-latexpdf:8.1.3
LABEL maintainer="Jens Frey <jens.frey@coffeecrew.org>" Version="2024-11-02"

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get -y install git gcc g++ python3-dev wget openjdk-17-jdk-headless plantuml docutils nginx

WORKDIR /usr/share/plantuml/
RUN rm -rf plantuml.jar && \
     wget "https://sourceforge.net/projects/plantuml/files/plantuml.jar" --no-check-certificate && \
     mkdir -p /usr/local/plantuml/ && ln -sf /usr/share/plantuml/plantuml.jar /usr/local/plantuml/plantuml.jar

WORKDIR /docs
ADD requirements.txt /docs
RUN pip install --upgrade pip && pip3 install -r requirements.txt

ADD default.template /etc/nginx/templates/default.template

WORKDIR /workspaces

COPY .bashrc /root/.bashrc
COPY topydo.conf /etc/topydo.conf

ENV LC_ALL=C