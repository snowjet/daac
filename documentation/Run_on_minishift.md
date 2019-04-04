# Minishift
The basic steps
* Setup CLI to access ImageStream
* Build the container
* Upload to your image stream
* Deploy the container

Remember to do your oc login

## Setup CLI to access ImageStream

```bash
minishift docker-env
```

$ minishift docker-env
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.101:2376"
export DOCKER_CERT_PATH="/Users/john/.minishift/certs"
export DOCKER_API_VERSION="1.24"
# Run this command to configure your shell:
# eval $(minishift docker-env)

```bash
eval $(minishift docker-env)
```

Login to docker on OpenShift

```bash
docker login -u developer -p $(oc whoami -t) $(minishift openshift registry)
```

## Build the container
The tag is important, this assumes you used html5

[a relative link](../README.md)


## Upload to your image stream
Tag your build in the image stream
```bash
docker tag html5 $(minishift openshift registry)/myproject/html5
```
Push your container
```bash
docker push $(minishift openshift registry)/myproject/html5
```

## Deploy the container
User your new image
```bash
oc new-app --image-stream=html5 --name=html5
```

Expose your environment and access
```bash
oc expose service html5 --path="/root"
```