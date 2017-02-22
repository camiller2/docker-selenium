#!/bin/bash

function usage {
    echo "Usage: build.sh <component> <selenium-version> <docker-version-to-output>"
    echo "   Example: build.sh hub 3.0.1 0.1.0"
    exit 1
}


if [ -z "$1" ]
  then
    usage
fi

if [ -z "$2" ]
  then
    usage
fi

if [ -z "$3" ]
  then
    MY_VERSION=local
  else
    MY_VERSION=$3
fi

function split_string {
  IN=$1
  arrIN=(${IN//./ })
  INDEX=$2
  echo ${arrIN[$INDEX]}
}

SELENIUM_MAJOR=$(split_string $2 0)
SELENIUM_MINOR=$(split_string $2 1)
SELENIUM_PATCH=$(split_string $2 2)

function selenium_usage {
   echo "invalid selenium version. expected <major>.<minor>.<patch> e.g. 3.2.1"
   exit 1
}

if [ -z "$SELENIUM_MAJOR" ]
  then
     selenium_usage
fi

if [ -z "$SELENIUM_MINOR" ]
  then
     selenium_usage
fi

if [ -z "$SELENIUM_PATCH" ]
  then
     selenium_usage
fi

echo $SELENIUM_MAJOR
echo $SELENIUM_MINOR
echo $SELENIUM_PATCH

BUILD_ARGS="--build-arg SELENIUM_MAJOR_VERSION=$SELENIUM_MAJOR --build-arg SELENIUM_MINOR_VERSION=$SELENIUM_MINOR --build-arg SELENIUM_PATCH_VERSION=$SELENIUM_PATCH"

VERSION=$MY_VERSION make build $1
