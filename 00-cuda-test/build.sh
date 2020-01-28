#!/bin/bash

mkdir -p tmp/docker-build
cp -r /usr/local/cuda/samples ./tmp/docker-build

docker build --rm -t devicequery .
