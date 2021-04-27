#!/bin/bash

cd "$(dirname $0)" && pwd -P

rm -rf ./submodules
  if [[ ! -d ./submodules ]]
  then
      mkdir ./submodules
  fi
 
pushd .
  cd submodules
  git clone --depth=1 --branch staging https://github.com/example-react-app.git
  git clone --depth=1 --branch staging https://github.com/example-python-backend.git
popd

# To use the repo after --depth=1
# git fetch  --unshallow
# Convert a shallow repository to a complete one, removing all the limitations of shallow repositories.
  
