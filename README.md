# Jena Riot

Docker image: [stain/jena](https://hub.docker.com/r/stain/jena/)

This docker image exposes the [Apache Jena](https://jena.apache.org/)
command line tool [riot](https://jena.apache.org/documentation/io/#command-line-tools)
and its variants `turtle`, `ntriples`, `nquads`, `trig` and  `rdfxml`.

## Usage

    docker run stain/jena riot http://www.w3.org/2013/TurtleTests/SPARQL_style_prefix.ttl

For documentation, try:

    docker run stain/jena riot --help

The default working directory of the image is `/rdf`, which can be used with Docker's
`--volume` for processing local files.

    docker run --volume /home/stain/Downloads:/rdf stain/jena riot db-uniprot-ls.ttl

