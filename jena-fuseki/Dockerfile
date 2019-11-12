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


#FROM alpine:3.4
#RUN apk add --update openjdk8-jre pwgen bash wget ca-certificates && rm -rf /var/cache/apk/*
FROM openjdk:8-jre-alpine
RUN apk add --update pwgen bash curl ca-certificates && rm -rf /var/cache/apk/*

MAINTAINER Stian Soiland-Reyes <stain@apache.org>



# Update below according to https://jena.apache.org/download/ and
# corresponding *.tar.gz.sha512 from https://www.apache.org/dist/jena/binaries/
ENV FUSEKI_SHA512 1960d3e057cdcaaa0811b33b57b86145fb0fb675eee1a6dd2d27a111313689e70ba8fa36b9ca66784cf9130ae5753bf50e32e82d9e3a7bba2786a0fc4ae7f056
ENV FUSEKI_VERSION 3.13.1
# Tip: No need for https as we've coded the sha512 above
ENV ASF_MIRROR_EU http://www.eu.apache.org/dist/
ENV ASF_MIRROR_US http://www.us.apache.org/dist/
ENV ASF_ARCHIVE http://archive.apache.org/dist/
#

# Config and data
VOLUME /fuseki
ENV FUSEKI_BASE /fuseki


# Installation folder
ENV FUSEKI_HOME /jena-fuseki

WORKDIR /tmp
# sha512 checksum
RUN echo "$FUSEKI_SHA512  fuseki.tar.gz" > fuseki.tar.gz.sha512
# Download/check/unpack/move in one go (to reduce image size)
RUN     (curl -sS --fail $ASF_MIRROR_EU/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz || \
         curl -sS --fail $ASF_MIRROR_US/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz || \
         curl -sS --fail $ASF_ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz \
        ) > fuseki.tar.gz && \
        sha512sum -c fuseki.tar.gz.sha512 && \
        tar zxf fuseki.tar.gz && \
        mv apache-jena-fuseki* $FUSEKI_HOME && \
        rm fuseki.tar.gz* && \
        cd $FUSEKI_HOME && rm -rf fuseki.war

# Test the install with it's ping resource
RUN apk add --no-cache tini
RUN /jena-fuseki/fuseki-server & \
    /sbin/tini timeout -t 30 /bin/sh -c " \
    echo 'waiting...'; sleep 5; \
    until curl -sS --fail 'http://localhost:3030/$/ping'; do echo 'waiting...'; sleep 5; done"

# No need to kill Fuseki as our shell will exit

# As "localhost" is often inaccessible within Docker container,
# we'll enable basic-auth with a random admin password
# (which we'll generate on start-up)
COPY shiro.ini /jena-fuseki/shiro.ini
COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh


COPY load.sh /jena-fuseki/
COPY tdbloader /jena-fuseki/
RUN chmod 755 /jena-fuseki/load.sh /jena-fuseki/tdbloader
#VOLUME /staging


# Where we start our server from
WORKDIR /jena-fuseki
EXPOSE 3030
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/jena-fuseki/fuseki-server"]
