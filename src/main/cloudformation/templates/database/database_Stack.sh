#!/bin/bash

cd "$(dirname $0)" && pwd -P

source ../../run/variables.sh
source ../../run/functions.sh

subject="database"

templateFile=$(ls *Template.yml)
if [[ -z "$templateFile" ]]; then
  echo $subject TemplateFile not found
fi

params1="${parameters}"

read -n1 -p "Do that? [Update, Delete, Create]" doit 
case $doit in  
  u|U) stackUpdate "${stackPrefix}-${subject}" $templateFile $params1 ;; 
  c|C) stackCreate "${stackPrefix}-${subject}" $templateFile $params1 ;; 
  d|D) stackDelete "${stackPrefix}-${subject}" ;; 
  *) echo dont know ;; 
esac