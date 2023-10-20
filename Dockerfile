FROM sphinxdoc/sphinx-latexpdf:7.1.2
LABEL maintainer="Jens Frey <jens.frey@coffeecrew.org>" Version="2023-10-20"

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

ENV PYTHONPATH=/usr/local/lib/python3.11/site-packages/
ADD default.template /etc/nginx/templates/default.template

WORKDIR /workspaces

RUN echo "alias rs=\"sed -e 's|##SERVER_PORT##|\${HTTP_SERVER_PORT:-8000}|g' -e 's|##SERVER_BUILD_DIR|/workspaces/\$(ls /workspaces)/build/html|g' /etc/nginx/templates/default.template > /etc/nginx/sites-available/default && service nginx restart\"" >> ~/.bashrc
