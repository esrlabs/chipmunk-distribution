#!/bin/bash

set -eux

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Usage: $0 /path/to/file.tar.gz"
    exit 1
fi

tar_file="$1"

# # Check if the file exists
# if [ ! -f "$tar_file" ]; then
#     echo "File not found: $tar_file"
#     exit 1
# fi

# Extract the directory containing the TAR_FILE
tar_dir="$(dirname "$tar_file")"

# Check if the chipmunk directory exists
if [ -d "$tar_dir/chipmunk" ]; then
    echo "Directory chipmunk exists. Clearing contents ..."
    rm -rf "$tar_dir/chipmunk"/*
else
    echo "Creating directory chipmunk ..."
    mkdir "$tar_dir/chipmunk"
fi

# Extract the filename without extension
filename=$(basename "$tar_file" .tar.gz)

# Change to the directory containing TAR_FILE
cd "$tar_dir"

# Untar the file to the chipmunk directory
tar -xzf "$filename.tar.gz" -C chipmunk

# Change to the chipmunk directory
cd chipmunk

# Display the contents of the chipmunk directory
ls -l

# Print the current working directory
pwd