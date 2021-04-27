#!/bin/bash

cd "$(dirname $0)" && pwd -P

source ../../run/variables.sh
source ../../run/functions.sh

# Cleaning
echo Cleaning previous ECR Repositories...
# sh ../../run/utility/deleteAllContainerImages.sh
deleteRepositoryImages $environment $projectName

subject="repository"

templateFile=$(ls *Template.yml)
if [[ -z "$templateFile" ]]; then
  echo $subject TemplateFile not found
fi
#stackCreate "${stackPrefix}-${subject}" $templateFile "${parameters}"

# Notes to
# FORCE A NEW DEPLOYMENT
# aws ecs update-service --cluster pythonbackendCluster --service pythonbackend --force-new-deployment

params1="${parameters} ParameterKey=Certificate,ParameterValue=${certificateArn} ParameterKey=HostedZoneName,ParameterValue=${hostedZone} ParameterKey=Subdomain,ParameterValue=${Subdomain}"

read -n1 -p "Do that? [Update, Delete, Create]" doit 
case $doit in  
  u|U) stackUpdate "${stackPrefix}-${subject}" $templateFile $params1 ;; 
  c|C) stackCreate "${stackPrefix}-${subject}" $templateFile $params1 ;; 
  d|D) stackDelete "${stackPrefix}-${subject}" ;;
  *) echo dont know ;; 
esac