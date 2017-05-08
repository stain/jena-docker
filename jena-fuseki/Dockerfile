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
FROM java:8-jre-alpine
RUN apk add --update pwgen bash wget ca-certificates && rm -rf /var/cache/apk/*

MAINTAINER Stian Soiland-Reyes <stain@apache.org>



# Update below according to https://jena.apache.org/download/
ENV FUSEKI_SHA1 92f27e01268ad47737bafd164474e36238351c86
ENV FUSEKI_VERSION 2.6.0
ENV FUSEKI_MIRROR http://www.eu.apache.org/dist/
ENV FUSEKI_ARCHIVE http://archive.apache.org/dist/
#

# Config and data
VOLUME /fuseki
ENV FUSEKI_BASE /fuseki


# Installation folder
ENV FUSEKI_HOME /jena-fuseki

WORKDIR /tmp
# sha1 checksum
RUN echo "$FUSEKI_SHA1  fuseki.tar.gz" > fuseki.tar.gz.sha1
# Download/check/unpack/move in one go (to reduce image size)
RUN     wget -O fuseki.tar.gz $FUSEKI_MIRROR/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz || \
        wget -O fuseki.tar.gz $FUSEKI_ARCHIVE/jena/binaries/apache-jena-fuseki-$FUSEKI_VERSION.tar.gz && \
        sha1sum -c fuseki.tar.gz.sha1 && \
        tar zxf fuseki.tar.gz && \
        mv apache-jena-fuseki* $FUSEKI_HOME && \
        rm fuseki.tar.gz* && \
        cd $FUSEKI_HOME && rm -rf fuseki.war


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
