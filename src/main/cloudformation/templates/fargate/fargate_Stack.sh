#!/bin/bash


cd "$(dirname $0)" && pwd -P

source ../../run/variables.sh
source ../../run/functions.sh


subject="fargate"

# Query certificate ARN for current domain defined in variables.sh
certificateArn=$(aws acm list-certificates --region eu-west-1 --query 'CertificateSummaryList[?DomainName==`'${domain}'`].CertificateArn' --output text)
echo $certificateArn
if [[ -z "$certificateArn" ]]; then
  echo $subject CertificateArn not found
  exit 0;
fi


templateFile=$(ls *Template.yml)
if [[ -z "$templateFile" ]]; then
  echo $subject TemplateFile not found
  exit 0;
fi

params1="${parameters} ParameterKey=Certificate,ParameterValue=${certificateArn} ParameterKey=HostedZoneName,ParameterValue=${hostedZone} ParameterKey=Subdomain,ParameterValue=${Subdomain}"

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
