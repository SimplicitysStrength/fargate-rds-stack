#!/bin/bash

cd "$(dirname $0)" && pwd -P

source ../cloudformation/run/variables.sh
source ../cloudformation/run/functions.sh

accountId=$(aws sts get-caller-identity --query "Account" --output text)

ecr_domain="${accountId}.dkr.ecr.eu-west-1.amazonaws.com"

# Using variables.sh file for stacks names
echo $projectName $environment
ecr_folder=$(aws ecr describe-repositories --output text --query 'repositories[?repositoryName==`'${projectName}'-'${environment}'-pythonbackend`].repositoryName')
ecr_address="${ecr_domain}/${ecr_folder}"
echo "$ecr_address"

deleteRepositoryImages $environment $projectName

export database_DNS=$(aws rds describe-db-instances --query 'DBInstances[?DBSubnetGroup.DBSubnetGroupName==`'${projectName}-${environment}'-dbsubgr`].Endpoint.Address' --output text)
export env="prod"
export stamp=$(date +"%y-%m-%d %T")

echo $ecr_address

docker build ./submodules/$repoName/ --tag python-backend:latest --build-arg ENVRNMNT=$env --build-arg DBDNS=$database_DNS --build-arg BUILDSTAMP="${stamp}"

imageID=$(docker images -q -f "reference=python-backend:latest")
echo $imageID
docker tag $imageID $ecr_address

hashKey=$(aws ecr get-login-password --region eu-west-1)
docker login -u AWS -p $hashKey $ecr_domain

docker push ${ecr_address}


service=${projectName}-${environment}-Service
cluster=${projectName}-${environment}-Cluster
echo $service
echo $cluster


tasks=($(aws ecs list-tasks --cluster ${cluster} --query "taskArns[*]" --output text))

for task in $tasks; do
  echo $task
  {
    aws ecs stop-task --task $task --cluster $cluster
  }  &> /dev/null
done
echo Force new deployment
{
  aws ecs update-service --cluster $cluster --service $service --force-new-DeploymentController
}  &> /dev/null
