#!/bin/sh
dirName=${1-.}
csvFile=${2-metadata.csv}

for fileName in $( find "$dirName" -name '*.jpg' ) ; do
    baseName=$(basename $fileName)
    newName=$(cat "$csvFile" \
        | grep "$baseName" \
        | sed -e "s/\([^\,]*\),\([^\,]*\),\([^,]*\),\(.*\)/$dirName\/\2_\3_\4_\1/g")
    if [ -n "$newName" ]; then
        echo "renaming $fileName to $newName"
        mv "$fileName" "$newName"
    else
        echo "Couldnt found metadata for $fileName"
    fi
done;
