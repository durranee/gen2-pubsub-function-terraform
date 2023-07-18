#!/bin/bash

eval "$(jq -r '@sh "export FUNCTION_NAME=\(.function_name) REGION=\(.region) DL_TOPIC=\(.dl_topic)"')"

## fetch function information to get trigger name and then get the topic and subscription id by getting trigger information
trigger_name=$(gcloud functions describe ${FUNCTION_NAME} --region=${REGION} --format='value(eventTrigger.trigger)')
trigger_topic=$(gcloud eventarc triggers describe ${trigger_name} --location ${REGION} --format='value(transport.pubsub.topic)')
trigger_subscription=$(gcloud eventarc triggers describe ${trigger_name} --location ${REGION} --format='value(transport.pubsub.subscription)')

## update the trigger subscription to attach the dead-letter topic to it
gcloud pubsub subscriptions update ${trigger_subscription} --dead-letter-topic=${DL_TOPIC}

## return the trigger topic and subscription as json (required)
jq -n \
    --arg trigger_subscription "$trigger_subscription" \
    --arg trigger_topic "$trigger_topic" \
    '{"trigger_topic":$trigger_topic, "trigger_subscription":$trigger_subscription}'