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
FROM java:8-jre-alpine
#RUN apk add --update --no-cache openjdk8-jre bash wget ca-certificates && rm -rf /var/cache/apk/*
RUN apk add --update --no-cache bash wget ca-certificates && rm -rf /var/cache/apk/*
MAINTAINER Stian Soiland-Reyes <stain@apache.org>

# Update below according to https://jena.apache.org/download/ and
# corresponding *.tar.gz.sha512 from https://www.apache.org/dist/jena/binaries/
ENV JENA_SHA512 fada08a9b444999cc542eb23f0aa5f30369d0fac6a4c9fe6571721b33cf2e48af8ae857eb2eff7d306e2d3187d0c3516bdaea474a74e25cf00df746fd3a975f1
ENV JENA_VERSION 3.9.0
# Tip: No need for https as we've coded the sha512 above
ENV JENA_MIRROR http://www.eu.apache.org/dist/
ENV JENA_ARCHIVE http://archive.apache.org/dist/
#

WORKDIR /tmp
# sha512 checksum
RUN echo "$JENA_SHA512  jena.tar.gz" > jena.tar.gz.sha512
# Download/check/unpack/move in one go (to reduce image size)
RUN     wget -O jena.tar.gz $JENA_MIRROR/jena/binaries/apache-jena-$JENA_VERSION.tar.gz || \
        wget -O jena.tar.gz $JENA_ARCHIVE/jena/binaries/apache-jena-$JENA_VERSION.tar.gz && \
	sha512sum -c jena.tar.gz.sha512 && \
	tar zxf jena.tar.gz && \
	mv apache-jena* /jena && \
	rm jena.tar.gz* && \
	cd /jena && rm -rf *javadoc* *src* bat

# Add to PATH
ENV PATH $PATH:/jena/bin
# Check it works
RUN riot  --version

# Default dir /rdf, can be used with
# --volume
RUN mkdir /rdf
WORKDIR /rdf
#VOLUME /rdf
CMD ["/jena/bin/riot"]
