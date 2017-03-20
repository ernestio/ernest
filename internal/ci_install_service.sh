#!/bin/bash

ORG=$1
REPO=$2
BRANCH=$3

echo $ORG
echo $REPO
echo $BRANCH

mkdir -p /home/ubuntu/.go_workspace/src/github.com/$ORG/
cd /home/ubuntu/.go_workspace/src/github.com/$ORG/ && rm -rf $REPO && git clone git@github.com:$ORG/$REPO.git
cd /home/ubuntu/.go_workspace/src/github.com/$ORG/$REPO/
if [ -n "$BRANCH" ];
  then git checkout $BRANCH
fi
make deps
make install
