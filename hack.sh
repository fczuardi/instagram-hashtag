#!/bin/sh
HASHTAG="cuteDogs"
PAGESIZE="33"
OUTPUTDIR="json"
QUERY="ig_hashtag($HASHTAG)"

# Get the values below opening the hashtag page on a browser and inspecting the first /query request
# you can use the "Copy as curl" option of the developer tools
# You must fill the strings below for this script to work
#
COOKIEHEADER=""
XCSRFTOKENHEADER=""
STARTCURSOR=""

function getPage {

    curl 'https://www.instagram.com/query/' \
        -H 'cookie: '"$COOKIEHEADER"'' \
        -H 'x-csrftoken: '"$XCSRFTOKENHEADER"'' \
        -H 'referer: https://www.instagram.com/explore/tags/'"$HASHTAG"'/' \
        -H 'accept-encoding: gzip, deflate' \
        -H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
        -H 'accept: application/json, text/javascript, */*; q=0.01' \
        --data 'q='"$QUERY"'
        {
            media.after('"$1"'%2C+'"$PAGESIZE"')
            {
                nodes {
                    code,
                    id,
                    comments {
                        count
                    },
                    likes {
                        count
                    },
                    date,
                    display_src,
                    owner {
                        username
                    }
                },
                page_info
            }
        }&ref=tags::show' \
        --compressed \
    | jq . \
    > "$2"
}

START="$STARTCURSOR"
mkdir -p "$OUTPUTDIR"
OUTPUTFILE="$OUTPUTDIR/$START.json"
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
