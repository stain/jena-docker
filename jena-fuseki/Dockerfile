#   Licensed to the Apache Software Foundation (ASF) under one or more
#   contributor license agreements.  See the NOTICE file distributed with
#   this work for additional information regarding copyright ownership.
#   The ASF licenses this file to You under the Apache License, Version 2.0
#   (the "License"); you may not use this file except in compliance with
#   the License.  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.


FROM eclipse-temurin:17-jre-alpine
MAINTAINER Stian Soiland-Reyes <stain@apache.org>

ENV LANG C.UTF-8
RUN set -eux; \
    apk -U upgrade; \
    apk add bash curl ca-certificates findutils coreutils gettext pwgen procps tini; \
    rm -rf /var/cache/apk/*


# Update below according to https://jena.apache.org/download/ 
# and checksum for apache-jena-fuseki-4.x.x.tar.gz.sha512
ENV FUSEKI_SHA512 78074d87d4c022ef7e89b8394d2b14ead447a9201d52795d8c9adab0e03341cffc883abb849dab340bbecfc18654e1d126a47d8936241e8e2f036b0d66294c7d
ENV FUSEKI_VERSION 4.8.0
ENV ASF_MIRROR https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=
ENV ASF_ARCHIVE https://archive.apache.org/dist/

LABEL org.opencontainers.image.url https://github.com/stain/jena-docker/tree/master/jena-fuseki
LABEL org.opencontainers.image.source https://github.com/stain/jena-docker/
LABEL org.opencontainers.image.documentation https://jena.apache.org/documentation/fuseki2/
LABEL org.opencontainers.image.title "Apache Jena Fuseki"
LABEL org.opencontainers.image.description "Fuseki is a SPARQL 1.1 server with a web interface, backed by the Apache Jena TDB RDF triple store."
LABEL org.opencontainers.image.version ${FUSEKI_VERSION}
LABEL org.opencontainers.image.licenses "(Apache-2.0 AND (GPL-2.0 WITH Classpath-exception-2.0) AND GPL-3.0)"
LABEL org.opencontainers.image.authors "Apache Jena Fuseki by https://jena.apache.org/; this image by https://orcid.org/0000-0001-9842-9718"

# Config and data
ENV FUSEKI_BASE /fuseki


# Installation folder
ENV FUSEKI_HOME /jena-fuseki

WORKDIR /tmp
# published sha512 checksum
RUN echo "$FUSEKI_SHA512  fuseki.tar.gz" > fuseki.tar.gz.sha512
# Download/check/unpack/move in one go (to reduce image size)
RUN     (curl --location --silent --show-error --fail --retry-connrefused --retry 3 --output fuseki.tar.gz ${ASF_MIRROR}jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz || \
    curl --fail --silent --show-error --retry-connrefused --retry 3 --output fuseki.tar.gz $ASF_ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz) && \
    sha512sum -c fuseki.tar.gz.sha512 && \
    tar zxf fuseki.tar.gz && \
    mv apache-jena-fuseki* $FUSEKI_HOME && \
    rm fuseki.tar.gz* && \
    cd $FUSEKI_HOME && rm -rf fuseki.war && chmod 755 fuseki-server

# Test the install by testing it's ping resource. 20s sleep because Docker Hub.
RUN  $FUSEKI_HOME/fuseki-server & \
    sleep 20 && \
    curl -sS --fail 'http://localhost:3030/$/ping' 

# No need to kill Fuseki as our shell will exit after curl

# As "localhost" is often inaccessible within Docker container,
# we'll enable basic-auth with a random admin password
# (which we'll generate on start-up)
COPY shiro.ini $FUSEKI_HOME/shiro.ini
COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh


COPY load.sh $FUSEKI_HOME/
COPY tdbloader $FUSEKI_HOME/
COPY tdbloader2 $FUSEKI_HOME/
RUN chmod 755 $FUSEKI_HOME/load.sh $FUSEKI_HOME/tdbloader $FUSEKI_HOME/tdbloader2
#VOLUME /staging

# Create a fuseki user and group
RUN addgroup -S fuseki && \
    adduser -G fuseki -S -D -H fuseki

# Where we start our server from
WORKDIR $FUSEKI_HOME
RUN chown -R fuseki:fuseki $FUSEKI_HOME

# Make sure we start with empty /fuseki
RUN mkdir -p $FUSEKI_BASE; \
    rm -rf $FUSEKI_BASE/*; \
    chown -R fuseki:fuseki $FUSEKI_BASE
VOLUME $FUSEKI_BASE

EXPOSE 3030
USER fuseki

ENTRYPOINT ["/sbin/tini", "--", "sh", "/docker-entrypoint.sh"]
CMD ["/jena-fuseki/fuseki-server"]

