# Jena Riot

* Docker image: [stain/jena](https://hub.docker.com/r/stain/jena/)
* Base images: [anapsix/alpine-java](https://hub.docker.com/r/anapsix/alpine-java/):jre8, [alpine](https://hub.docker.com/r/_/alpine/)
* Source: [Dockerfile](https://github.com/stain/jena-docker/blob/master/jena/Dockerfile), [Apache Jena](http://jena.apache.org/download/)


[![Build Status](https://travis-ci.org/stain/jena-docker.svg)](https://travis-ci.org/stain/jena-docker)

[![](https://badge.imagelayers.io/stain/jena:latest.svg)](https://imagelayers.io/?images=stain/jena:latest 'Get your own badge on imagelayers.io')


This docker image exposes the [Apache Jena](https://jena.apache.org/)
command line tool [riot](https://jena.apache.org/documentation/io/#command-line-tools)
and its variants `turtle`, `ntriples`, `nquads`, `trig` and  `rdfxml`.

## License

Different licenses apply to files added by different [Docker layers](https://imagelayers.io/?images=stain%2Fjena).

* stain/jena [Dockerfile](https://github.com/stain/jena-docker): [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
* Apache Jena (`/jena` in the image): [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
  See also: `docker run stain/jena cat /jena/NOTICE`
* Oracle JDK (`/opt/jdk` in the image): [Oracle Binary Code License Agreement for the Java SE Platform Products and JavaFX](http://java.com/license)
  See also: `docker run stain/jena cat /opt/jdk/THIRDPARTYLICENSEREADME.txt`
* Alpine Linux (rest of `/`): Unknown ([GPL 3?](http://www.gnu.org/licenses/gpl-3.0))

## Usage

    docker run stain/jena riot http://www.w3.org/2013/TurtleTests/SPARQL_style_prefix.ttl

For [documentation](https://jena.apache.org/documentation/io/#command-line-tools)
about `riot`, try:

    docker run stain/jena riot --help

```
    riot [--time] [--check|--noCheck] [--sink] [--base=IRI] [--out=FORMAT] file ...
      Parser control
          --sink                 Parse but throw away output
          --syntax=NAME          Set syntax (otherwise syntax guessed from file extension)
          --base=URI             Set the base URI (does not apply to N-triples and N-Quads)
          --check                Addition checking of RDF terms
          --strict               Run with in strict mode
          --validate             Same as --sink --check --strict
          --rdfs=file            Apply some RDFS inference using the vocabulary in the file
          --nocheck              Turn off checking of RDF terms
          --stop                 Stop parsing on encountering a bad RDF term
      Output control
          --output=FMT           Output in the given format, streaming if possible.
          --formatted=FMT        Output, using pretty printing (consumes memory)
          --stream=FMT           Output, using a streaming format
      Time
          --time                 Time the operation
      Symbol definition
          --set                  Set a configuration symbol to a value
      General
          -v   --verbose         Verbose
          -q   --quiet           Run with minimal output
          --debug                Output information for debugging
          --help
          --version              Version information
```

The default working directory of the image is `/rdf`, which can be used with
[Docker volumes](https://docs.docker.com/userguide/dockervolumes/) to
process local files.

    docker run --volume /home/stain/Downloads:/rdf stain/jena riot db-uniprot-ls.ttl

Note that `riot` does not currently have an option to specify the
output file (see [JENA-1032](https://issues.apache.org/jira/browse/JENA-1032)),
so you will need to use your host shell's
pipeline:

    docker run --volume /home/stain/Downloads:/rdf stain/jena riot db-uniprot-ls.ttl > /home/stain/Downloads/db-uniprot-ls.nq

To executable multiple `riot` commands within a Docker container:

    docker run -it stain/jena sh

Note that this image is based on a minimal
[Alpine Linux](http://alpinelinux.org/) installation.

## Contact

For any feedback on Jena, `riot` and this Docker image, please use
the [users@jena](https://jena.apache.org/help_and_support/)
mailing list.

For any issues with Jena or `riot`, feel free to
[raise a bug](https://jena.apache.org/help_and_support/bugs_and_suggestions.html).

For any issues with this Docker image
and its [Dockerfile](https://github.com/stain/jena-docker/),
please raise a [pull request](https://github.com/stain/jena-docker/pulls) or
[issue](https://github.com/stain/jena-docker/issues).
