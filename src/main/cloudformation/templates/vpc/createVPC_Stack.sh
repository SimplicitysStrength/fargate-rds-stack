#!/bin/bash

cd "$(dirname $0)" && pwd -P

source ../../run/variables.sh
source ../../run/functions.sh


subject="vpc"

templateFile=$(ls *Template.yml)
if [[ -z "$templateFile" ]]; then
  echo $subject TemplateFile not found
fi

read -n1 -p "Do that? [Update, Delete, Create]" doit 
case $doit in  
  u|U) stackUpdate "${stackPrefix}-${subject}" $templateFile "${parameters}" ;; 
  c|C) stackCreate "${stackPrefix}-${subject}" $templateFile "${parameters}" ;;
  d|D) stackDelete "${stackPrefix}-${subject}" ;; 
  *) echo dont know ;; 
esac