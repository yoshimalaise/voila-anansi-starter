#!/bin/bash

# create build directory if it doesn't exist
if [ -d ./build ]   # For file "if [ -f /home/rama/file ]"
then
    echo "build directory exists"
else
    mkdir ./build
fi

# empty build directory
rm -rf ./build/*


# create the docker image
docker buildx build --platform linux/amd64 --output type=oci,dest="./build/container.tar" .

# use the lima apptainer vm to convert the tar to sif file
limactl start --mount-writable apptainer

limactl shell apptainer apptainer build --writable-tmpfs ./build/container.sif docker-archive:build/container.tar