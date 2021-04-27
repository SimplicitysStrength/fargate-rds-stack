#!/bin/bash

cd "$(dirname $0)" && pwd -P

source ../cloudformation/run/variables.sh
source ../cloudformation/run/functions.sh

# Using variables.sh file for stacks names
aws_s3name=$(aws s3api list-buckets --query 'Buckets[?Name==`'${projectName}-${environment}'-pythonbackend`].Name' --output text)

pushd .
  cd ./submodules/$frontendrepo

  npm install
  npm run build:prod

  if [[ ! -d ./build ]]; then
    echo Failed build prod
    exit 0
  fi
  cd ./build
  
  aws s3 cp . s3://$aws_s3name --recursive
  
popd