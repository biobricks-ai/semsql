#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Create brick directory
brickpath="$localpath/brick"
mkdir -p $brickpath
echo "Brick path: $brickpath"

# Define the ontologies.yaml list URL
onto_url="https://raw.githubusercontent.com/INCATools/semantic-sql/main/src/semsql/builder/registry/ontologies.yaml"
# Define the obo.tsv list URL
obo_url="https://raw.githubusercontent.com/INCATools/semantic-sql/main/reports/obo.tsv"

# Retrieve and unpack the files

cat \
        <(
                # Via ontologies.yaml:
                #
                # NOTE using CPAN::Meta::YAML because nothing needs to be installed (no need
                # for YAML::Tiny, YAML::PP, etc.). It parses fine even if it is meant to be
                # a limited feature set of YAML.
                curl -L $onto_url | tee $brickpath/ontologies.yaml | perl -MCPAN::Meta::YAML -0777 -e '
                my $text  = <>;
                my $ontos = CPAN::Meta::YAML->read_string($text)
                          or die CPAN::Meta::YAML->errstr;
                for my $onto (keys %{ $ontos->[0]{ontologies} }) {
                        print "https://s3.amazonaws.com/bbop-sqlite/${onto}.db.gz", "\n";
                }
                '
        ) \
        <(
                # Via obo.tsv:
                curl -L $obo_url | tee $brickpath/obo.tsv | perl -lpe '
                        my $onto = $_;
                        $_ = qq{https://s3.amazonaws.com/bbop-sqlite/${onto}.db.gz}
                '
        ) \
        | sort -u | xargs -n1 -P$(nproc) wget -P $brickpath

echo "Download done."
