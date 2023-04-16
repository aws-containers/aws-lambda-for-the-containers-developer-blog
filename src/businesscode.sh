#!/bin/sh
set -euo pipefail

rm -rf aws-lambda-for-the-containers-developer-blog

git clone https://github.com/${AWS_LAMBDA_FOR_THE_CONTAINERS_DEVELOPER_BLOG_GITHUB_USERNAME}/aws-lambda-for-the-containers-developer-blog
cd aws-lambda-for-the-containers-developer-blog/src/hugo_web_site
/tmp/hugo
aws s3 cp ./public/ s3://${AWS_LAMBDA_FOR_THE_CONTAINERS_DEVELOPER_BLOG_BUCKET}/ --recursive