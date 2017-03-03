#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Please provide a release name."
    exit 1
fi
new_release="releases/doily-$1.tar.gz"
tar -czf "${new_release}" doily default.conf
ls -l "${new_release}"
