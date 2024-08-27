#!/bin/bash

REGISTRY_URL=quay.io/cuongdm8499
IMAGE_NAME=vks-terminal
IMAGE_TAG=v1.0.0

build() {
  echo "Building..."
  docker build -t ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG} .
}

push() {
  echo "Pushing..."
  docker tag ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG} ${REGISTRY_URL}/${IMAGE_NAME}:latest
  docker push ${REGISTRY_URL}/${IMAGE_NAME}:${IMAGE_TAG}
  docker push ${REGISTRY_URL}/${IMAGE_NAME}:latest
}

case $1 in
build)
  build
  ;;
push)
  push
  ;;
*)
  echo "Usage: $0 {build|push}"
  exit 1
  ;;
esac
