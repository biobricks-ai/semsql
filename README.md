# SemSQL

<a href="https://github.com/biobricks-ai/semsql/actions"><img src="https://github.com/biobricks-ai/semsql/actions/workflows/bricktools-check.yaml/badge.svg?branch=main"/></a>

## Description

> SemSQL: standard SQL views for RDF/OWL ontologies
>
> This project provides a standard collection of SQL tables/views for ontologies, such that you can make queries like this,
> to find all terms starting with `Abnormality` in [HPO](https://obofoundry.org/ontology/hp).

## Dataset availale at <https://github.com/INCATools/semantic-sql>



## Usage
```{R}
biobricks::brick_install("semsql")
biobricks::brick_pull("semsql")
biobricks::brick_load("semsql")
```
