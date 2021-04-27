#!/bin/bash

cd "$(dirname $0)" && pwd -P

source ../../run/variables.sh
source ../../run/functions.sh


subject="cloudfront"
# Query certificate ARN for current domain defined in variables.sh
certificateArn=$(aws acm list-certificates --region us-east-1 --query 'CertificateSummaryList[?DomainName==`'${domain}'`].CertificateArn' --output text)

templateFile=$(ls *Template.yml)
if [[ -z "$templateFile" ]]; then
  echo $subject TemplateFile not found
fi

params1="${parameters} ParameterKey=HostedZoneName,ParameterValue=${hostedZone} ParameterKey=Subdomain,ParameterValue=${Subdomain}  ParameterKey=Certificate,ParameterValue=${certificateArn}"

# Cleaning
echo Cleaning Bucket...
#sh ../../run/utility/deleteAllBuckets.sh
deleteBucket $environment $projectName

read -n1 -p "Do that? [Update, Delete, Create]" doit 
case $doit in  
u|U) 
  stackUpdate "${stackPrefix}-${subject}" $templateFile "${params1}"
  ;; 
c|C) 
  stackCreate "${stackPrefix}-${subject}" $templateFile "${params1}"
  ;; 
d|D) 
  stackDelete "${stackPrefix}-${subject}" 
  ;; 
esac
