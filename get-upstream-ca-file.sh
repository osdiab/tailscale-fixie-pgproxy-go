#!/usr/bin/env sh
# from https://curl.se/docs/caextract.html

curl --etag-compare etag.txt --etag-save etag.txt --remote-name https://curl.se/ca/cacert.pem
