#!/bin/sh
set -euo pipefail

###############################################################
# The container initializes before processing the invocations #
###############################################################

echo Installing the latest version of Hugo...
cd /tmp
export LATESTHUGOBINARYURL=$(curl -s https://api.github.com/repos/gohugoio/hugo/releases/latest | jq -r '.assets[].browser_download_url' | grep Linux-64bit.tar.gz | grep extended)
export LATESTHUGOBINARYARTIFACT=${LATESTHUGOBINARYURL##*/}
curl -LO $LATESTHUGOBINARYURL
tar -zxvf $LATESTHUGOBINARYARTIFACT
./hugo version

###############################################
# Processing the invocations in the container #
###############################################

while true
do
  # Create a temporary file
  HEADERS="$(mktemp)"
  # Get an event. The HTTP request will block until one is received
  EVENT_DATA=$(curl -sS -LD "$HEADERS" -X GET "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/next")
  # Extract request ID by scraping response headers received above
  REQUEST_ID=$(grep -Fi Lambda-Runtime-Aws-Request-Id "$HEADERS" | tr -d '[:space:]' | cut -d: -f2)

  ############################
  # Run my arbitrary program #
  ############################

  /businesscode.sh

  ############################

  # Send the response
  curl -X POST "http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime/invocation/$REQUEST_ID/response"  -d '{"statusCode": 200}'

done