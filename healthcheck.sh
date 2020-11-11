#!/bin/bash

THRESHOLD=600

LAST=$(wee_debug --info --verbosity=0 2>&1 | awk '/Last good timestamp/{gsub("\(|\)","");print $NF}')
NOW=$(date +%s)

DIFF=$(($NOW-$LAST))

if [[ $DIFF -gt $THRESHOLD ]] ; then
    echo "Heathcheck failed Last:$LAST > Now:$NOW = Diff:$DIFF"
    exit 1
else
    echo "All good: $LAST"
    exit 0
fi
