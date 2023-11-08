#!/bin/bash

# Prompt the user for confirmation
read -r -p "Requested operation requires superuser privilege. Are you sure you want to continue? (y/n): " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo "Executing package installation steps ..."
else
    echo "Aborted installation. Chipmunk package will not be installed."
fi

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide the package path as an argument to install_deb_package script."
    exit 1
fi

deb_package="$1"

sudo dpkg -i "$deb_package"

