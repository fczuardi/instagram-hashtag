#!/bin/sh
dirName=${1-.}
csvFile=${2-metadata.csv}

for fileName in $( find "$dirName" -name '*.jpg' ) ; do
    baseName=$(basename $fileName)
    newName=$(cat "$csvFile" \
        | grep "$baseName" \
        | sed -e "s/\([^\,]*\),\([^\,]*\),\([^,]*\),\(.*\)/$dirName\/\2_\3_\4_\1/g")
    echo "renaming $fileName to $newName"
    mv "$fileName" "$newName"
done;
