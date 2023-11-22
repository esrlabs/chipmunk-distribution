#!/bin/bash

set -eux

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/file.tar.gz"
    exit 1
fi

tar_file="$1"

# Check if the file exists
if [ ! -f "$tar_file" ]; then
    echo "File not found: $tar_file"
    exit 1
fi

# Check if the chipmunk directory exists
if [ -d "../chipmunk" ]; then
    echo "Directory chipmunk exists. Clearing contents ..."
    rm -rf ../chipmunk/*
else
    echo "Creating directory chipmunk ..."
    mkdir ../chipmunk
fi

# Untar the file to the chipmunk directory
tar -xzf "$tar_file" -C ../chipmunk

cd ../chipmunk



