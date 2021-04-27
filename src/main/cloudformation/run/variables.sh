#!/bin/bash


environment="staging"
# environment="reporting"

projectName="projectXYZ"

repoName=$projectName

hostedZone="example.com"

Subdomain=$environment
domain=${environment}.${hostedZone}

stackPrefix="${projectName}-${environment}"

parameters="ParameterKey=EnvironmentName,ParameterValue=${stackPrefix}"
