#!/bin/sh
HASHTAG="visaourbanaiz"
PAGESIZE="33"
QUERY="ig_hashtag($HASHTAG)"

# Get the values below opening the hashtag page on a browser and inspecting the first /query request
# you can use the "Copy as curl" option of the developer tools
# You must fill the strings below for this script to work
STARTCURSOR="AQCEcKAZMAsmGiMK1OXCmQNG91xZnLdyhV-mwZqp3i8ZPfF6w8xpqsUKd6STMRUupnZnc1yYVY0jwFTiIeFnTXidQ56k0dsix2L63NhuqIXmdA"
COOKIEHEADER=""
XCSRFTOKENHEADER=""

function getPage {
    curl 'https://www.instagram.com/query/' \
        -H 'cookie: '"$COOKIEHEADER"'' \
        -H 'x-csrftoken: '"$XCSRFTOKENHEADER"'' \
        -H 'referer: https://www.instagram.com/explore/tags/'"$HASHTAG"'/' \
        -H 'accept-encoding: gzip, deflate' \
        -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
        -H 'accept: application/json, text/javascript, */*; q=0.01' \
        --data 'q='"$QUERY"'+%7B+media.after('"$1"'%2C+'"$PAGESIZE"')+%7B%0A++count%2C%0A++nodes+%7B%0A++++caption%2C%0A++++code%2C%0A++++comments+%7B%0A++++++count%0A++++%7D%2C%0A++++date%2C%0A++++dimensions+%7B%0A++++++height%2C%0A++++++width%0A++++%7D%2C%0A++++display_src%2C%0A++++id%2C%0A++++is_video%2C%0A++++likes+%7B%0A++++++count%0A++++%7D%2C%0A++++owner+%7B%0A++++++id%0A++++%7D%2C%0A++++thumbnail_src%0A++%7D%2C%0A++page_info%0A%7D%0A+%7D&ref=tags%3A%3Ashow' \
        --compressed \
    | jq . \
    > "$2"
}

START="$STARTCURSOR"
OUTPUTFILE="json/$START.json"
getPage "$START" "$OUTPUTFILE"
HASNEXTPAGE=$(jq ".media.page_info.has_next_page" "$OUTPUTFILE")

while "$HASNEXTPAGE"; do
    echo "$START $OUTPUTFILE"
    getPage "$START" "$OUTPUTFILE"
    HASNEXTPAGE=$(jq ".media.page_info.has_next_page" "$OUTPUTFILE")
    ENDCURSOR=$(jq -r ".media.page_info.end_cursor" "$OUTPUTFILE")
    START="$ENDCURSOR"
    OUTPUTFILE="json/$START.json"
done
