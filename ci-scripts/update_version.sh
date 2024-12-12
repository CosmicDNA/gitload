#!/bin/bash

# Fetch the current version from the control file
current_version=$(grep -Po '(?<=Version: ).*' debian/control)

# Increment the version number
IFS='.' read -r major minor patch <<< "$current_version"
new_version="$major.$minor.$((patch + 1))"

# Update the control file with the new version
sed -i "s/Version: $current_version/Version: $new_version/" debian/control
echo "Updated version: $new_version"
