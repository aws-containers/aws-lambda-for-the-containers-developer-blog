#!/bin/bash
set -euo pipefail

STACK_NAME="$1"

APIG_URL=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query 'Stacks[0].Outputs[?OutputKey==`ApiGatewayUrl`].OutputValue' --output text)

echo "Issuing request against API Gateway URL: $APIG_URL"
curl -vi $APIG_URL