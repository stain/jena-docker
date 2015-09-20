# Docker files for Jena

This repository hosts [Docker](https://www.docker.com/) recipes for distributing 
[Apache Jena](http://jena.apache.org/).

Two Docker images are available:

 - [jena](jena/) - `riot` command line and friends, for use on the command line
 - [fuseki](fuseki/) - the [Fuseki 2](http://jena.apache.org/documentation/fuseki2/) server
 
These are currently available from the Docker Hub as:

 - [stain/jena](https://hub.docker.com/r/stain/jena/)
 - [stain/jena-fuseki](https://hub.docker.com/r/stain/jena-fuseki/)

Note that although these Docker images are based on the official Apache Jena releases, 
they do **not** constitute official releases from Apache Software Foundation.

See also [JENA-909](https://issues.apache.org/jira/browse/JENA-909) which proposes
official Jena Docker images.
 
## Building

```shell
docker build -t jena jena
docker build -t jena-fuseki jena-fuseki
```
 
## Dockerfile overview

The `Dockerfile`s for both images use [anapsix/alpine-java](https://hub.docker.com/r/anapsix/alpine-java/) as a base image, which 
unlike [java](https://hub.docker.com/r/anapsix/alpine-java/) clocks in at just [174 vs 488 MB](https://imagelayers.io/?images=anapsix%2Falpine-java:jre8,java:8-jre). 

**TODO**: Avoid third-party `anapsix/alpine-java` base image and use only `alpine` base image (or equivalent). Issue: Alpine Linux only comes with Open JDK 7, but Jena 3 needs Java 8.

The `ENV` variables like `JENA_VERSION` and `FUSEKI_VERSION` determines which version of Jena and Fuseki are downloaded. Updating the version also requires updating the `JENA_SHA1` and `FUSEKI_SHA1` variables, which values
should match the official Jena download `.tar.gz.sha1` hashes, as approved in their release `[VOTE]` emails.  

Note that the [Jena download page](http://jena.apache.org/download/) do not link directly to the `sha` checksums, these can be found by modifying the `.md5` download links to a `sha1` extension, e.g. http://www.apache.org/dist/jena/binaries/apache-jena-3.0.0.tar.gz.sha1 or http://www.apache.org/dist/jena/binaries/apache-jena-fuseki-2.3.0.tar.gz.sha1

The `JENA_MIRROR` and `FUSEKI_MIRROR` should be http://www.eu.apache.org/dist/ or http://www.us.apache.org/dist/ - **not** http://www.apache.org/dist/ 

To minimize layer size, there's a single `RUN` with `wget`, `sha1sum`, `tar zxf` and `mv` - thus the temporary files are not part of the final image.

Some files from the Apache Jena distributions are stripped, e.g. javadocs and the `fuseki.war` file.

The Fuseki image includes some [helper scripts](jena-fuseki/load.sh) to do [tdb loading](https://jena.apache.org/documentation/tdb/commands.html) using `fuseki-server.jar`.

