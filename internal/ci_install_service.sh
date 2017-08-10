#!/bin/bash

ORG=$1
REPO=$2
BRANCH=$3

echo $ORG
echo $REPO
echo $BRANCH

mkdir -p /go/src/github.com/$ORG/
cd /go/src/github.com/$ORG/ && rm -rf $REPO && git clone git@github.com:$ORG/$REPO.git
cd /go/src/github.com/$ORG/$REPO/
if [ -n "$BRANCH" ];
  then git checkout $BRANCH
fi
make deps
make install
