#!/bin/bash

# Delete all aws containerImages in all repositories / ! \
repositories=($(aws ecr describe-repositories --output text --query "repositories[*].repositoryName"))
if [[ -z $repositories ]]
then 
  echo "No repositories found";
  exit 1; 
fi
for repository in "${repositories[@]}";
do
  echo $repository
  imageIds=($(aws ecr list-images --repository-name $repository --query 'imageIds[*].imageDigest' --output text))
  if [[ -z $imageIds ]]
  then 
    echo "No images found in ${repository}";
  else
    for imageId in "${imageIds[@]}";
    do
      aws ecr batch-delete-image --repository-name $repository --image-ids imageDigest=$imageId
    done;
  fi
done;