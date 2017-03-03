#!/bin/bash

if [[ -z "${1}" ]]; then
    echo "Please provide a release name."
    exit 1
fi
tar -cf "releases/doily-${1}.tar" doily default.conf
