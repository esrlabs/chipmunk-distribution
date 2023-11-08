#!/bin/bash

# Prompt the user for confirmation
read -r -p "You're about to execute some commands as root. Are you sure you want to continue? (y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Executing package build steps ..."
else
    echo "Aborted installation. Chipmunk package will not be installed."
fi

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide the destination path as an argument to build_package script."
    exit 1
fi

destination_folder="$1"

# Navigate one directory up because
# dpkg-buildpackage needs to open file debian/changelog
cd ..

# Check if chipmunk package is installed
if dpkg -l | grep -q chipmunk; then
    echo "Chipmunk package is installed. Removing it ..."
    sudo dpkg -r chipmunk
else
    echo "Chipmunk package is not installed."
fi

# Check if old chipmunk exists
if [ -L /usr/bin/chipmunk ]; then
		echo "Removing existing version of chipmunk"
		sudo rm /usr/bin/chipmunk
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
