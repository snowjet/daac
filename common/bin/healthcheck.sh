#!/bin/bash

for line in $(supervisorctl status | awk '{print $2}'); do
  if [[ ! ${line} == RUNNING ]]; then
        echo ${line}
        exit 255
  fi
done