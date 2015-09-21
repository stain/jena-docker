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

# ideally:
#FROM alpine:3.xx
#RUN apk add --update openjdk8-jre && rm -rf /var/cache/apk/*
# .. but as JDK8 is not yet in alpine, instead use:
FROM anapsix/alpine-java:jre8
MAINTAINER Stian Soiland-Reyes <stain@apache.org>

# Update below according to https://jena.apache.org/download/
ENV JENA_SHA1 0563da22020560ea2b08cc011bebf878c10515ce
ENV JENA_VERSION 3.0.0
ENV JENA_MIRROR http://www.eu.apache.org/dist/
#

WORKDIR /tmp
# sha1 checksum
RUN echo "$JENA_SHA1  jena.tar.gz" > jena.tar.gz.sha1
# Download/check/unpack/move in one go (to reduce image size)
RUN wget -O jena.tar.gz $JENA_MIRROR/jena/binaries/apache-jena-$JENA_VERSION.tar.gz && \
	sha1sum -c jena.tar.gz.sha1 && \
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
