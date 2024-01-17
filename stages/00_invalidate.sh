#!/bin/sh

set -eu

# Get local [ath]
localpath=$(pwd)
echo "Local path: $localpath"

# Define the S3 bucket for the dataset
s3_bucket="bbop-sqlite"

# Create the checksum directory
checksumpath="$localpath/checksum"
echo "Checksum path: $checksumpath"
mkdir -p "$checksumpath"

aws s3 ls --no-sign-request $s3_bucket | sort > $checksumpath/s3-listobjects.txt
