#/bin/sh

docker build --build-arg OC_DEV_TOOLS=true --build-arg LOCAL_AUTH_USER_PWHASH=55CeGsfZ1M932 --build-arg LOCAL_AUTH_USER=user --build-arg DESKTOP=mate -t vdi5 -f vdi5 .
docker tag vdi5 docker-registry-default.cloudapps.anzlab.bne.redhat.com/rdp-demo/vdi5:latest
docker push docker-registry-default.cloudapps.anzlab.bne.redhat.com/rdp-demo/vdi5:latest
