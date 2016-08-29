#!/bin/sh

jsonDir="json"
outputFile="metadata.csv"

rm "$outputFile"
for fileName in $(ls "$jsonDir"); do
    jq -r '.media.nodes[] | (.display_src|sub(".*/";"")|sub("\\?ig_cache.*"; ""))+","+.owner.username+","+(.date|strftime("%Y-%m-%dT%H:%M:%SZ")|tostring)+","+.code+","+(.comments.count|tostring)+","+(.likes.count|tostring)+","+(.id|tostring)' \
        "$jsonDir/$fileName"\
    >> "$outputFile"
    # break
done
