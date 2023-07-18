#!/bin/bash

eval "$(jq -r '@sh "export FUNCTION_NAME=\(.function_name) REGION=\(.region) DL_TOPIC=\(.dl_topic)"')"

trigger_name=$(gcloud functions describe ${FUNCTION_NAME} --region=${REGION} --format='value(eventTrigger.trigger)')
trigger_topic=$(gcloud eventarc triggers describe ${trigger_name} --location ${REGION} --format='value(transport.pubsub.topic)')
trigger_subscription=$(gcloud eventarc triggers describe ${trigger_name} --location ${REGION} --format='value(transport.pubsub.subscription)')

jq -n \
    --arg trigger_subscription "$trigger_subscription" \
    --arg trigger_topic "$trigger_topic" \
    '{"trigger_topic":$trigger_topic, "trigger_subscription":$trigger_subscription}'