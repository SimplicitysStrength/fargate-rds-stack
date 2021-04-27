# Fargate Cloudformation template infrastructure

### Contents

Complete infra as code stack using aws cloudformation

Deploying the backend in a container ran by fargate

Using managed services for database, static hosting for a react app and redirects

### Prerequisite

1. [Access keys for CLI, SDK, & API access](https://console.aws.amazon.com/iam/home?region=eu-west-1#/security_credentials)
   
   Create an access key to make programmatic calls to AWS from the AWS Command Line Interface

2. Install the AWS CLI
   
   1. [GitHub - aws/aws-cli: Universal Command Line Interface for Amazon Web Services](https://github.com/aws/aws-cli)
   
   2. > ```
      > sudo python -m pip install awscli
      > ```
   
   3. Run `aws configure` 
      Fill with the values from the csv file downloaded at step 1

3. ( Optionnal - To test debug stacks ) Install Taskcat 
   
   1. [GitHub - aws-quickstart/taskcat: Test all the CloudFormation things! (with TaskCat)](https://github.com/aws-quickstart/taskcat)
   2. > ```
      > sudo python -m pip install taskcat
      > ```