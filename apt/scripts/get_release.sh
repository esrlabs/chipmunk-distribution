#!/bin/bash

set -eux

url_chipmunk='https://github.com/esrlabs/chipmunk/releases/latest'
response=$(curl -s -L -I $url_chipmunk)
realTagUrl=$(echo "$response" | grep -i "location" | awk -F' ' '{print $2}')
version=$(echo "$realTagUrl" | awk -F'/' '{print $NF}' | sed 's/v//' | sed 's/\r$//')

echo "Packaging chipmunk version - '$version'"
chipmunk_package_url="https://github.com/esrlabs/chipmunk/releases/download/$version/chipmunk@$version-linux-portable.tgz"

# Folder structure
output_dir=$(pwd)
source_dir=$(dirname "$0")
working_dir=/tmp/chipmunk_work_dir

echo "source_dir = '$source_dir'"

# Create an empty working directory
sudo rm -rf "$working_dir"
mkdir -p "$working_dir"

# Store the release in the working_dir folder
cd "$working_dir"
wget $chipmunk_package_url

# replace hardcoded renaming of release
mv chipmunk@3.10.3-linux-portable.tgz chipmunk@3.10.3-linux-portable.tar.gz

