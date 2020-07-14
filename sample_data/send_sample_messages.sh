#!/bin/bash

# Author: Gary A. Stafford
# Sends sample messages to AWS IoT Core Topic
# Usage: sh send_sample_messages.sh raw_data_small.json
# NOTE: Requires the use of jq

if [[ $# -ne 1 ]]; then
  echo "Script requires 1 parameter..."
  exit 1
fi

dataFile=$1 # "raw_data_small.json"

count=0

jq -c '.[]' "${dataFile}" | while read -r i; do
  { aws iot-data publish \
    --topic "iot-device-data" \
    --qos 0 \
    --payload "$(echo "${i}" | base64)" \
    >/dev/null; } 2>&1

  count=$((count + 1))
  echo Messages sent: $count
done
