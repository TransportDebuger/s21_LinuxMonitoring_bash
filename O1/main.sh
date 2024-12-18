#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Error: Wrong parameters count. It must have single parameter."
  exit 1
fi

input=$1

# Regular expression for detecting number in parameter
if [[ $input =~ ^[+-]?[0-9]*[.]?[0-9]*$ ]]; then
    echo "Error: Parameter can't be a number" ;
else
    echo $input ;
fi        
