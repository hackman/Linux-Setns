#!/bin/bash

current_version=$(awk '/^version/{print $2}' META.yml)

if [ -z "$1" ]; then
	echo "Usage: new_version"
	exit 1
fi
new_version=$1

sed -i "/^version/s/$current_version/$new_version/" META.yml
sed -i "1s/$current_version/$new_version/" README
sed -i "/our\s*\$VERSION/s/$current_version/$new_version/" lib/Linux/Unshare.pm
