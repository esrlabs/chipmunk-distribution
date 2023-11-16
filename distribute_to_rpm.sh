#!/bin/bash
set -eux
sudo dnf update -y
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-$(arch)-rpms
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y
sudo subscription-manager repos --enable codeready-builder-for-rhel-9-x86_64-rpms
sudo yum update "*dnf*" libsolv
sudo yum install -y createrepo rpm-build rpm-sign wget gcc python3 yum-utils rpm-devel

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

# Create a source tarball (the same as those available on Github) using git-archive to make
# sure there are no additional files included in the source package
cd "$source_dir"
cat $output_dir/rpm_rhel/chipmunk.spec | sed -e "s/@VERSION@/$version/" > "$working_dir/SPECS/chipmunk.spec"
echo "--------------------------------final spec file below----------------------------------------------------------------------------"
cat $working_dir/SPECS/chipmunk.spec
echo "--------------------------------end of spec file---------------------------------------------------------------------------------"

# Build packages
cd "$working_dir/SPECS"
rpmbuild --define "_topdir $working_dir" -ba chipmunk.spec

cd "$source_dir"
# Copy all the created files and clean up
cp "$working_dir"/{RPMS/x86_64,SRPMS}/* "$output_dir"
sudo rm -rf "$working_dir"
