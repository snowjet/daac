# OpenShift
The basic steps
* Prerequisites
* Build the container

## Prerequisites

OpenShift Registry is enabled and exposed see [OpenShift Documentation](https://docs.openshift.com/container-platform/3.11/install_config/registry/index.html)

Login: docker login -u (user) (exposed_docker_registry_route) 
* Note this the route for the Docker Registry Container not the Console
* The docker console will provide some commands that may be useful
* the url by default will be something like: docker-registry-default.(your url)

You may have to add the exposed url to the insecure registries if using Docker. Without this you will get a certificate error.

Assumption: Your project is called myproject

## Use OpenShift to Build Container and Deploy

```bash
cat build.env | oc new-app https://github.com/snowjet/DaaC.git#OpenShift-Dev --build-env-file=-
```

## Build the container
The tag is important, this assumes you used html5

[Readme File](../README.md)


## Upload to your image stream
Tag your build in the image stream
```bash
docker tag html5 (exposed_docker_registry_route):[port]/myproject/html5:latest
```
Push your container
```bash
docker push (exposed_docker_registry_route):[port]/myproject/html5:latest
```

:[port] is required for HTTPS e.g. 443, this should be reflected in insecure registries

## Deploy the container
Your project
```bash
oc project myproject
```

User your new image
```bash
oc new-app --image-stream=html5:latest --name=html5
```

Expose your environment and access
```bash
oc expose service html5 --path="/root"
```

## References
[Blog Post: Remotely Push and Pull Container Images](https://blog.openshift.com/remotely-push-pull-container-images-openshift/)