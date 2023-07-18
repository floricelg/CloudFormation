#!/bin/bash

set -e # Exit immediately if a command returns error

# Variables
STACK_NAME='AutoscalingStack'
ROOT_TEMPLATE='root-template.yaml'
OUTPUT_TEMPLATE='packaged-root-template.yaml'
TEMPLATE_BUCKET='florianagerea' # Please change this to your own S3 bucket for packaging CloudFormation templates.
REGION='eu-west-1'
WEB_SERVER_IMAGE='ami-00cb737355da466a9'
WEBSITE_BUCKET='my-website-source-flori' # Please change this to your own S3 bucket for sample website source packages.

# Package the nested templates and produce an output template from the root template
aws cloudformation package \
    --template $ROOT_TEMPLATE \
    --s3-bucket $TEMPLATE_BUCKET \
    --output-template-file $OUTPUT_TEMPLATE \
    --region $REGION

# Deploy the output template of the package command
aws cloudformation deploy \
    --template-file $OUTPUT_TEMPLATE \
    --stack-name $STACK_NAME \
    --parameter-overrides WebServerImage=$WEB_SERVER_IMAGE WebsiteBucket=$WEBSITE_BUCKET \
    --capabilities CAPABILITY_IAM \
    --region $REGION