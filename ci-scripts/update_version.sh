#!/bin/bash

# Fetch the current version from the changelog
current_version=$(head -n 1 debian/changelog | grep -Po 'gitload \(\K[^)]*')
echo "Fetched current version: $current_version"

# Increment the version number
IFS='.' read -r major minor patch <<< "$current_version"
new_version="$major.$minor.$((patch + 1))"
echo "New version: $new_version"

# Prepare the new changelog entry
current_date=$(date -R)
new_entry="gitload ($new_version) unstable; urgency=low\n\n  * Updated version to $new_version.\n\n -- Daniel de Souza <daniel@cosmicdna.co.uk>  $current_date\n"

# Update the changelog by adding the new entry at the top
{ echo -e "$new_entry"; cat debian/changelog; } > debian/changelog.new && mv debian/changelog.new debian/changelog

echo "Updated changelog with version: $new_version"