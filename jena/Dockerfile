
#FROM alpine:3.2
#RUN apk add --update openjdk7-jre && rm -rf /var/cache/apk/*

# Need JDK 8 instead
FROM anapsix/alpine-java:jre8
MAINTAINER Stian Soiland-Reyes <stain@apache.org>

ENV JENA_SHA1 0563da22020560ea2b08cc011bebf878c10515ce
ENV JENA_VERSION 3.0.0
ENV JENA_MIRROR http://www.eu.apache.org/dist/

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
