#!/bin/bash

set -eux

# url_chipmunk='https://github.com/esrlabs/chipmunk/releases/latest'

url_chipmunk='https://github.com/esrlabs/chipmunk/releases/tag/3.10.5'

response=$(curl -s -L -I $url_chipmunk)
realTagUrl=$(echo "$response" | grep -i "location" | awk -F' ' '{print $2}')
version="3.10.5"

echo "Packaging chipmunk version - '$version'"
chipmunk_package_url="https://github.com/esrlabs/chipmunk/releases/download/$version/chipmunk@$version-linux-portable.tgz"

# Folder structure
working_dir=/tmp/chipmunk_work_dir

# Create an empty working directory
sudo rm -rf "$working_dir"
mkdir -p "$working_dir"

# Store the release in the working_dir folder
cd "$working_dir"
wget $chipmunk_package_url

# Find the file starting with "chipmunk@"
file=$(find . -type f -name 'chipmunk@*' -print -quit)

# Check if a file is found
if [ -n "$file" ]; then
  # Extract the basename without extension
  filename=$(basename "$file" .tgz)
  
  # Extract the version from the filename
  version=$(echo "$filename" | awk -F'[@-]' '{print $2}')
  echo "VERSION=$version" >> $GITHUB_ENV

  # Move the file with the new extension
  mv "$file" "$filename.tar.gz"
  echo "TAR_FILE=$working_dir/$filename.tar.gz" >> $GITHUB_ENV
else
  echo "File not found."
fi


