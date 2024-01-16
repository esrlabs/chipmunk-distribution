#!/bin/bash
set -eux

sudo apt-get install rpm

if [ -z "$1" ]
then
echo "Latest version number unavailable, exiting."
exit 1
else
version="$1"
fi

if [ -z "$2" ]
then
echo "Tag number unavailable, exiting."
exit 1
else
tag="$2"
fi

echo "Packaging chipmunk version - '$version'"
chipmunk_package="chipmunk@$version-linux-portable.tar.gz"

# Folder structure
output_dir=$(pwd)
working_dir=/tmp/chipmunk_work_dir

echo "output_dir = '$output_dir'"

# Create an empty working directory for rpmbuild
mkdir -p "$working_dir"/{BUILD,SOURCES,SPECS,RPMS,SRPMS}

# Store the source tar in SOURCES folder
cd "$working_dir"
ls -la
cp "$chipmunk_package" "$working_dir/SOURCES"

if [ ! -f $working_dir/SOURCES/$chipmunk_package ]; then
        echo "Unable to download latest release tar. Exiting rpm package creation!"
        exit 1
fi

# Update spec to refer to the latest version of chipmunk.
cat $output_dir/rpm_rhel/rpm_specs/chipmunk.spec | sed -e "s/@VERSION@/$version/" > "$working_dir/SPECS/chipmunk.spec"

# Build package using chipmunk.spec
cd "$working_dir/SPECS"
rpmbuild --define "_topdir $working_dir" -ba chipmunk.spec

# Copy all the created files and clean up
cp "$working_dir"/RPMS/x86_64/* "$output_dir"

# Rename package to match chipmunk assets naming convention
cd "$output_dir"
mv chipmunk-$version-0.$(arch).rpm chipmunk@$tag-linux-$(arch).rpm