#!/bin/bash

cd "$(dirname $0)" && pwd -P

sh ../cloudformation/run/variables.sh

database_DNS=$(aws rds describe-db-instances --query 'DBInstances[?DBSubnetGroup.DBSubnetGroupName==`'${projectName}-${environment}'-dbsubgr`].Endpoint.Address' --output text)

docker build ./submodules/example-python-backend/ --tag python-backend  --build-arg ENVRNMNT=prod --build-arg DBDNS=$database_DNS


containerId=$(docker images -q -f "reference=python-backend")

docker run $containerId shell < echo 'Prod migration setup'
