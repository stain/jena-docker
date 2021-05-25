# Jena command line tools

* Docker image: [stain/jena](https://hub.docker.com/r/stain/jena/)
* Base images: [openjdk](https://hub.docker.com/r/_/openjdk/):11-jre-slim-buster
* Source: [Dockerfile](https://github.com/stain/jena-docker/blob/master/jena/Dockerfile), [Apache Jena](http://jena.apache.org/download/)


[![Build Status](https://travis-ci.com/stain/jena-docker.svg)](https://travis-ci.com/stain/jena-docker)

[![](https://images.microbadger.com/badges/image/stain/jena.svg)](https://microbadger.com/images/stain/jena "stain/jena")

[![](https://images.microbadger.com/badges/version/stain/jena:4.0.0.svg)](https://github.com/stain/jena-docker/tree/master/jena "Jena 4.0.0")

This docker image exposes the [Apache Jena](https://jena.apache.org/)
command line tool [riot](https://jena.apache.org/documentation/io/#command-line-tools)
and its variants (e.g. `turtle`, `rdfxml`), in addition to the other Jena
command line tools, like `rdfcompare`, `tdbloader` and `sparql`.

## License

Different licenses apply to files added by different Docker layers:

* stain/jena [Dockerfile](https://github.com/stain/jena-docker/blob/master/jena/Dockerfile): [Apache License, version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
* Apache Jena (`/jena` in the image): [Apache License, version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
  See also: `docker run stain/jena cat /jena/NOTICE`
* OpenJDK (`/usr/local/openjdk-11/` in the image): [GPL 2.0 with Classpath exception](https://openjdk.java.net/legal/gplv2+ce.html)
  See `/usr/local/openjdk-11/legal/` in image
* Debian GNU/Linux (rest of `/`): [GPL 3](http://www.gnu.org/licenses/gpl-3.0) and [compatible licenses](https://www.debian.org/legal/licenses/), see `/usr/share/*/license` in image



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
[Debian GNU/Linux](https://www.debian.org/) installation. You can use
the `apt` command to install additional tools.


## Other command line tools

All the command line tools of the Jena distribution are included.

    docker run stain/jena ls /jena/bin

- arq
- infer
- iri
- juuid
- nquads
- ntriples
- qparse
- rdfcat
- rdfcompare
- rdfcopy
- rdfparse
- rdfxml
- riot
- rset
- rsparql
- rupdate
- schemagen
- sparql
- tdbbackup
- tdbdump
- tdbloader
- tdbloader2
- tdbloader2common
- tdbloader2data
- tdbloader2index
- tdbquery
- tdbstats
- tdbupdate
- trig
- turtle
- uparse
- update
- utf8
- wwwdec
- wwwenc

Example:

```
stain@biggie:~/src/jena/apache-jena$ docker run stain/jena sparql -h
sparql --data=<file> --query=<query>
  Control
      --explain              Explain and log query execution
      --repeat=N or N,M      Do N times or N warmup and then M times (use for timing to overcome start up costs of Java)
      --optimize=            Turn the query optimizer on or off (default: on)
  Time
      --time                 Time the operation
  Query Engine
      --engine=EngineName    Register another engine factory[ref]
      --unengine=EngineName   Unregister an engine factory
  Dataset
      --data=FILE            Data for the datset - triple or quad formats
      --graph=FILE           Graph for default graph of the datset
      --namedGraph=FILE      Add a graph into the dataset as a named graph
  Results
      --results              Results format (Result set: text, XML, JSON, CSV, TSV; Graph: RDF serialization)
      --desc=                Assembler description file
  Query
      --query, --file        File containing a query
      --syntax, --in         Syntax of the query
      --base                 Base URI for the query
  Symbol definition
      --set                  Set a configuration symbol to a value
      --strict               Operate in strict SPARQL mode (no extensions of any kind)
  General
      -v   --verbose         Verbose
      -q   --quiet           Run with minimal output
      --debug                Output information for debugging
      --help
      --version              Version information
```

Note that you will need to use `docker run --volume` to make local files accessible to these commands.

## GitHub Action

@vemonet has made a GitHub Action [vemonet/jena-riot-action](https://github.com/marketplace/actions/validate-rdf-with-jena)
which can be used to validate or convert RDF files on commits to GitHub:

```yaml
- uses: vemonet/jena-riot-action@v3.14
  with:
    input: my_file.ttl
    convert: --output=NQUADS
```

See <https://github.com/vemonet/jena-riot-action> for details.

## Contact

For any feedback on Jena, `riot` and this Docker image, please use
the [users@jena](https://jena.apache.org/help_and_support/)
mailing list.

For any issues with Jena or `riot`, feel free to
[raise a bug](https://jena.apache.org/help_and_support/bugs_and_suggestions.html).


For any issues with the packaging in this Docker image, or
its [Dockerfile](https://github.com/stain/jena-docker/),
please raise a [pull request](https://github.com/stain/jena-docker/pulls) or
[issue](https://github.com/stain/jena-docker/issues).

