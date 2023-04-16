#!/bin/bash
set -euo pipefail

STACK_NAME="$1"

SQS_URL=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`QueueUrl`].OutputValue' --output text)

echo "Putting a message in SQS URL: $SQS_URL"
aws sqs send-message --queue-url $SQS_URL --message-body '{"message": "does not matter"}'