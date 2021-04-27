# Fargate Cloudformation template infrastructure

### Contents

Complete infra as code stack using aws cloudformation

Deploying the backend in a container ran by fargate

Using managed services for database, static hosting for a react app and redirects

Some research and links about cloudformation stack building made over at [practices](https://github.com/SimplicitysStrength/fargate-rds-stack/blob/master/src/main/cloudformation/docs/practices.md)

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

3. ( Optionnal - To test & debug stacks ) Install Taskcat 
   
   1. [GitHub - aws-quickstart/taskcat: Test all the CloudFormation things! (with TaskCat)](https://github.com/aws-quickstart/taskcat)
   2. > ```
      > sudo python -m pip install taskcat
      > ```

### Architecture

Template is split between 5 parts, each can be created, deleted and tested independently. These folders are all under `/src/main/cloudformation/templates`
Alphabetical order here.

* Cloudfront 
  
  * Domain registry reference (Not included*)
  
  * SSL certificate reference (Not included*)
  
  * Static frontend hosting using S3 and cloudfront redirects

* Database
  
  * RDS - db.t3.micro

* Fargate
  
  * ECS Cluster - containers running the backend app. 
  
  * ElasticLoadbalancer
  
  * Scaling policy
  
  * SecurityGroups

* Repository
  
  * ECR Adress

* Vpc
  
  * Subnets
  
  * Routes
  
  * Gateways


**Not included*** parts should be created manually using the aws console, via web browser or event the cli. These will then be queried and used by reference from the default aws zone. It's recommended to create them only once as they both have a flat cost on creation. Unlike other services with time based fees.

All cloudformation templates and scripts use some variables in located in `/src/main/cloudformation/run/variables.sh` 

The environment variable is usefull to clone the stack for prod , staging and testing scenarios. Using the domain prefix staging.example.com by default.


### Usage

Each template part is created with it's own bash script, the bash script itself calls the aws-cli for ease of use.

In practice these will only be run when launching new environments or when doing stack updates.
Automating stack creations was not part of the needs for the initial project.

Once all the 5 parts of the cloudformation stack are running, some handy build scripts can be found in the `/src/main/continuous_deployment` folder.

These will vary depending on the project's technology and needs. Hopefuly these can be used as startup points.

* `/src/main/continuous_deployment/build_pythonbackend.sh` [here](https://github.com/SimplicitysStrength/fargate-rds-stack/blob/master/src/main/continuous_deployment/build_pythonbackend.sh)
  
  Creates a docker container image with the backend part and publishes it, triggering a replacement on the ECS Cluster. It is accesible under  `/api` path, or directly through the loadbalancer dns.

* `/src/main/continuous_deployment/build_reactapp.sh` [here](https://github.com/SimplicitysStrength/fargate-rds-stack/blob/master/src/main/continuous_deployment/build_reactapp.sh)
  
  Bundles the frontend app and uploads it to the S3 static hosting, to be served directly through cloudfront redirects on the root `/`
  

### Pricing

This template is by no means the best or the cheapest way to create such architecture on AWS. With a configurable loadbalancer, an autoscalling group, and many optins to choose from, it allows for a small to medium project to start and grow organically.
I would say the initial cost is buying the domain and certificate, after that running costs for the ecs cluster, vpc and database are around 10-20$ per month for one replica (At the time of writting)

[Pricing - AWSCertificate Manager](https://aws.amazon.com/en/certificate-manager/pricing/)
[AWS - Free tier](https://aws.amazon.com/en/free/)

### Testing

See taskcat in [practices](https://github.com/SimplicitysStrength/fargate-rds-stack/blob/master/src/main/cloudformation/docs/practices.md)



### What to expect in the future

* Create a demo pythonbackend app and a demo react app to replace example references.
  Although this template is currently used in production, i could not provide the source for these parts as they are private.

* Migrate bash scripts to codedeploy to avoid running scripts locally

* Make a more complete architectural diagram to ease learning AWS Cloudformation template pieces

* More scalability options discovered both on the rds and ecs parts
