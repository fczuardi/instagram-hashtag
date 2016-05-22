#!/bin/sh

jsonDir="json"
outputFile="urls.txt"
curlInputFile="curl-urls.txt"

for fileName in $(ls "$jsonDir"); do
    jq '.media.nodes[].display_src|sub("\\?ig_cache.*"; "")' \
        "$jsonDir/$fileName"\
    >> "$outputFile"
done

sed -e "s/^\"/url=\"/" -e 's/\"$/\"\'$'\n''-O\'$'\n''-L/' "$outputFile" > "$curlInputFile"
