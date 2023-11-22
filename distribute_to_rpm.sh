#!/bin/bash
set -eux

sudo apt-get install rpm

url_chipmunk='https://github.com/esrlabs/chipmunk/releases/latest'
response=$(curl -s -L -I $url_chipmunk)
realTagUrl=$(echo "$response" | grep -i "location" | awk -F' ' '{print $2}')
version=$(echo "$realTagUrl" | awk -F'/' '{print $NF}' | sed 's/v//' | sed 's/\r$//')

echo "Packaging chipmunk version - '$version'"
chipmunk_package_url="https://github.com/esrlabs/chipmunk/releases/download/$version/chipmunk@$version-linux-portable.tgz"

# Folder structure
output_dir=$(pwd)
source_dir=$(dirname "$0")
working_dir=/tmp/chipmunk_rpm_work_dir

echo "source_dir = '$source_dir'"

# Create an empty working directory for rpmbuild
sudo rm -rf "$working_dir"
mkdir -p "$working_dir"/{BUILD,SOURCES,SPECS,RPMS,SRPMS}

# Store the source tar in SOURCES folder
cd "$working_dir/SOURCES"
wget $chipmunk_package_url

if [ ! -f $working_dir/SOURCES/chipmunk@$version-linux-portable.tgz ]; then
        echo "Unable to download latest release tar. Exiting rpm package creation!"
        sudo rm -rf "$working_dir"
        exit 1
fi

# Update spec to refer to the latest version of chipmunk.
cd "$source_dir"
cat $output_dir/rpm_rhel/chipmunk.spec | sed -e "s/@VERSION@/$version/" > "$working_dir/SPECS/chipmunk.spec"

# Build package using chipmunk.spec
cd "$working_dir/SPECS"
rpmbuild --define "_topdir $working_dir" -ba chipmunk.spec

# Copy all the created files and clean up
cd "$source_dir"
cp "$working_dir"/{RPMS/x86_64,SRPMS}/* "$output_dir"
sudo rm -rf "$working_dir"

# Rename package to match chipmunk assets naming convention
cd "$output_dir"
mv chipmunk-$version-0.$(arch).rpm chipmunk@$version-linux-$(arch).rpm