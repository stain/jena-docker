FROM alpine:3.2
RUN apk add --update openjdk7-jre && rm -rf /var/cache/apk/*

ENV SHA1 0563da22020560ea2b08cc011bebf878c10515ce
ENV VERSION 3.0.0
ENV MIRROR http://www.eu.apache.org/dist/
WORKDIR /tmp
RUN echo "$SHA1  jena.tar.gz" > jena.tar.gz.sha1
RUN wget -O jena.tar.gz $MIRROR/jena/binaries/apache-jena-$VERSION.tar.gz && sha1sum -c jena.tar.gz.sha1 && tar zxfv jena.tar.gz && mv apache* /jena && rm jena.tar.gz*
ENV PATH $PATH:/jena/bin
CMD ["/jena/bin/riot"]




