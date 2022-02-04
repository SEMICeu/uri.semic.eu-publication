#!/bin/bash

FILE=$1
COMMIT=$2

jq --arg branchtag "$COMMIT"  -r ' .[] |=  . + {"type": "raw"} + {"directory" : .urlref} + {"repository":"https://github.com/SEMICeu/uri.semic.eu-generated" } + {"branchtag" : "\($branchtag)" } ' ${FILE}
