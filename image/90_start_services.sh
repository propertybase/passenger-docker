#!/bin/bash

IFS=',' read -ra SERVICE <<< "$START"
for i in "${SERVICE[@]}"; do
  rm -f "/etc/service/${i}/down"
done
