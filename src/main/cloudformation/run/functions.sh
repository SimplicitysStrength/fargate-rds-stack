#!/bin/bash



# Runs the Template file in the current directory
# Args... stackName , filePath, params
stackCreate ()
{
  
  declare stackName="${1}"
  declare filePath="${2}"
  declare params="${3}"
  
  # Cleaning
  aws cloudformation delete-stack --stack-name $stackName
  aws cloudformation wait stack-delete-complete --stack-name $stackName

  # Template creation init
  aws cloudformation create-stack --stack-name $stackName \
                                  --template-body "file://${filePath}" \
                                  --parameters $params \
                                  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
  

  echo Creating $stackName

  aws cloudformation wait stack-create-complete --stack-name $stackName

  echo Completed $stackName
}

stackDelete ()
{
  declare stackName="${1}"
  aws cloudformation delete-stack --stack-name $stackName
  echo Deleting $stackName
  aws cloudformation wait stack-delete-complete --stack-name $stackName
  echo Trashed $stackName
}

stackUpdate () 
{
  declare stackName="${1}"
  declare filePath="${2}"
  declare params="${3}"
  aws cloudformation update-stack --stack-name $stackName \
                                  --template-body "file://${filePath}" \
                                  --parameters $params \
                                  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM
  echo Updating $stackName
  aws cloudformation wait stack-update-complete --stack-name $stackName
  echo Updated $stackName
}

#deleteBucket $environment $projectName
deleteBucket ()
{
  declare env="${1}"
  declare projectName="${2}"
  # pythonbackend S3 Bucket
  fullBucketName=$(aws s3api list-buckets --query 'Buckets[?Name==`'${projectName}'-'${env}'-pythonbackend`].Name' --output text)
  echo $fullBucketName
  if [[ -z "${fullBucketName}" ]]; then
    echo Could not delete: Bucket not found...
    return 0
  fi
  aws s3 rb s3://${fullBucketName} --force
}

#deleteRepositoryImages $environment $projectName
deleteRepositoryImages ()
{ 
  declare env="${1}"
  declare projectName="${2}"
  repository=$(aws ecr describe-repositories --query 'repositories[?repositoryName==`'${projectName}'-'${env}'-pythonbackend`].repositoryName' --output text)
  echo $repository
  if [[ -z "${repository}" ]]; then
    echo Repository not found...
    return 0
  fi
  imageIds=($(aws ecr list-images --repository-name $repository --query 'imageIds[*].imageDigest' --output text))

  if [[ -z $imageIds ]]
  then 
    echo "No images found in ${repository}";
  else
    for imageId in "${imageIds[@]}";
    do
      echo $imageId
      aws ecr batch-delete-image --repository-name $repository --image-ids imageDigest=$imageId
    done;
  fi
}