#!/usr/bin/env bash

# Script to download files

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Create brick directory
brickpath="$localpath/brick"
mkdir -p $brickpath
echo "Brick path: $brickpath"

# Define the YAML list URL
list_url="https://raw.githubusercontent.com/INCATools/semantic-sql/main/src/semsql/builder/registry/ontologies.yaml"

# Retrieve and unpack the files
# NOTE using CPAN::Meta::YAML because nothing needs to be installed (no need
# for YAML::Tiny, YAML::PP, etc.). It parses fine even if it is meant to be
# a limited feature set of YAML.
curl -L $list_url | tee $brickpath/ontologies.yaml | perl -MCPAN::Meta::YAML -0777 -e '
my $text  = <>;
my $ontos = CPAN::Meta::YAML->read_string($text)
          or die CPAN::Meta::YAML->errstr;
for my $onto (keys %{ $ontos->[0]{ontologies} }) {
	print "https://s3.amazonaws.com/bbop-sqlite/${onto}.db.gz", "\n";
}
' | xargs -n1 -P$(nproc) wget -P $brickpath

echo "Download done."
