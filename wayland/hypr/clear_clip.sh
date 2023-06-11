#!/bin/bash

for i in $(cliphist list | awk -F " " '{ print $2 }'); do
    cliphist delete-query "$i"
done
