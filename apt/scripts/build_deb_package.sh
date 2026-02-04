#!/bin/bash

export DH_SHLIBDEPS_SKIP=1
set -eux

# Check if the script is being run with sudo
if [[ $EUID -ne 0 ]]; then
    echo "Requested operation requires superuser privilege and needs to be run with sudo. Please use: sudo $0" 1>&2
    exit 1
fi

if [ -z "$1" ]; then
    read -p "Enter the destination folder path: " destination_folder

    if [ ! -d "$destination_folder" ]; then
        echo "The specified destination folder does not exist. Please provide a valid path."
        exit 1
    fi
else
    destination_folder="$1"
    version="$2"
fi

 echo "Destination folder is set to: $destination_folder"

# Check if chipmunk package is installed
if dpkg-query -l chipmunk; then
    echo "Chipmunk package is installed. Removing it ..."
    dpkg -r chipmunk
else
    echo "Chipmunk package is not installed."
fi

# remove any old leftovers of chipmunk before builduing new package
if [ -L /usr/bin/chipmunk ]; then
		rm /usr/bin/chipmunk
fi

# navigate to apt folder in order to run build command
cd apt/debian
# Update the debian/changelog file with the new filename format
sed -i "s/chipmunk (.*) UNRELEASED;/chipmunk ($version) UNRELEASED;/" changelog

cd ..

# Build the package
dpkg-buildpackage -b

# Check if the destination folder exists, if not, create it
if [ ! -d "$destination_folder" ]; then
    echo "Creating destination folder: $destination_folder"
    mkdir -p "$destination_folder"
    chmod 755 "$destination_folder"
else
    echo "Destination folder: $destination_folder"
fi

# Rename package to match chipmunk assets naming convention
arch=$(dpkg-architecture -qDEB_BUILD_ARCH)
for file in ../chipmunk_*_"$arch".deb; do
    if [ -e "$file" ]; then
        new_name=chipmunk@$version-linux-$arch.deb
        install -m 644 "$file" "$destination_folder/$new_name"
        rm -f "$file"
    fi
done

# Verify renamed file
cd $destination_folder
ls -l
