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

 ```
 docker build -t jena jena
 docker build -t jena-fuseki jena-fuseki
 ```
 
## Dockerfile overview

The `Dockerfile`s for both images use [anapsix/alpine-java](https://hub.docker.com/r/anapsix/alpine-java/) as a base image, which 
unlike [java](https://hub.docker.com/r/anapsix/alpine-java/) clocks in at just 
