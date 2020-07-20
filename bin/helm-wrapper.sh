#!/bin/bash

helm_cmd=/usr/local/bin/helm-original
supported='enc dec view edit clean install template upgrade lint diff'
cmd=$1

if [[ " $supported " =~ .*\ $cmd\ .* ]]; then
    $helm_cmd secrets $@
else
    $helm_cmd $@
fi
