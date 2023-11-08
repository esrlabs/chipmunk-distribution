#!/bin/bash

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
fi

 echo "Destination folder is set to: $destination_folder"

# Navigate one directory up because
# dpkg-buildpackage needs to open file debian/changelog
cd ..

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

# Build the package
dpkg-buildpackage -b

# Check if the destination folder exists, if not, create it
if [ ! -d "$destination_folder" ]; then
    echo "Creating destination folder: $destination_folder"
    mkdir -p "$destination_folder"
else
    echo "Destination folder: $destination_folder"
fi

# Move the generated files to the destination folder
mv ../chipmunk_*.buildinfo ../chipmunk_*.changes ../chipmunk_*.deb ../chipmunk-dbgsym_* "$destination_folder"
