#!/bin/bash
VERSION=$1
NAMESPACE=$2
MAINTAINER=$3

echo "# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" > ./Dockerfile
echo "# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED." >> ./Dockerfile
echo "# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE" >> ./Dockerfile
echo "# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" >> ./Dockerfile
echo FROM $NAMESPACE/node-base:$VERSION >> ./Dockerfile
echo MAINTAINER $MAINTAINER >> ./Dockerfile 
echo "" >> ./Dockerfile
cat ./Dockerfile.txt >> ./Dockerfile
