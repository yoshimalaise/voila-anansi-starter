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
docker buildx build --no-cache --platform linux/amd64 --output type=oci,dest="./build/container.tar" .

# use the lima apptainer vm to convert the tar to sif file
limactl start --mount-writable apptainer

limactl shell apptainer apptainer build --writable-tmpfs ./build/container.sif docker-archive:build/container.tar

# generate the run script for Anansi
cat > ./build/auto_run.sh <<EOF
#!/bin/bash

cd "\$(dirname "\${BASH_SOURCE[0]}")"

export WEBSERVER_PORT=\${USER:3}

if [ -d ./data ]
then
    echo "data directory exists"
else
    mkdir ./data
fi

apptainer run \
    --env "HF_HOME=/app/resources/persisted/hugging_face_cache" \
    --env "WEBSERVER_PORT=\$WEBSERVER_PORT" \
    --bind ./data:/app/resources/persisted \
    ./container.sif &>> "./logs.txt"

echo "Waiting for webserver to start..."
until curl --output /dev/null --silent --head --fail http://localhost:\$WEBSERVER_PORT; do
    sleep 1
done
echo "Webserver is up."

# Open firefox in kiosk mode and point to the started container
firefox --kiosk localhost:\$WEBSERVER_PORT
EOF