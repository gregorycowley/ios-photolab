#!/bin/sh

# Find PNG images not referenced by any xib, m/h, and plist files
# Works from current directory downward.

refs=`find . -name '*.xib' -o -name '*.[mh]' -o -name '*.plist'`

for image in `find . -name '*.png'`
do
    image_basename=`basename $image`
    image_name=${image_basename%.*}
    if ! grep -q $image_name $refs; then
        echo $image
    fi
done