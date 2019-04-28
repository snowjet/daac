#/bin/sh

docker build --build-arg OC_DEV_TOOLS=true --build-arg DESKTOP=mate -t html5 --squash --compress -f Dockerfile .
docker tag html5 quay.io/rarm_sa/daac:latest
docker push quay.io/rarm_sa/daac:latest
