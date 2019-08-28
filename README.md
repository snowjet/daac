# DCaaS - Desktop Container as a Service

## Goal

Essentially create a Container Based VDI system running on OpenShift.

**Key Features:**

* Runs a graphical desktop ontop of OpenShift with default security controls
* OpenShift creates a random local user account for the desktop to exist within
* Uses Guacamole for the HTML5 Proxy
* XRDP is used to spawn the desktop. XRDP allows the desktop match the size of the current window. WHich means if you full screen your browser when logging in you will have a full screen desktop.
* Build a desktop on Mate (recommended), Gnome3 or XFCE

## Demo

!['HTML5-DaaC Demo'](https://raw.githubusercontent.com/snowjet/DaaC/master/demo/HTML5-DaaC.gif)

## Howto Build

**Build Arguments**

| Argument | Description                   | Value                  |
|----------|:------------------------------|:-----------------------|
| DESKTOP  | Selected Main Desktop Session | mate, gnome3 or xfce]  |
| OC_DEV_TOOLS | Install OpenShift Developer Tools | True or False  |

**Buildah Build**
```bash
buildah bud -f Dockerfile \
            -t html5:latest \
            --build-arg DESKTOP=mate \
            --build-arg OC_DEV_TOOLS=true \
            --squash --logfile ./buildlog .
```

**Docker Build**
For a docker build with guacamole that hooks it all together run.

```bash
docker build -f html5/Dockerfile \
             -t html5 \
             --build-arg OC_DEV_TOOLS=true \
             --build-arg DESKTOP=mate .
```

## HowTo Run in OpenShift

**Step 1. Modify the template to select your Container Repository**

I am using quay.io which is awesome! But you can use any repository that your OpenShift cluster can access. The default parameter to overide in the template is DAAC_IMAGE_NAME.

```yaml
parameters:
- description: Daac Image
  name: DAAC_IMAGE_NAME
  value: quay.io/rarm_sa/daac
```

**Step 2. Import Template into OpenShift**

Import the template from the repo:

```bash
oc apply -f openshift/daac-template.yml
```

**Step 3. Create the Applicaiton**

Create the application from the imported template. The two passwords which should be set and unqiue are for Postgres and Guacamole Admin
```bash
oc new-app --name mydaac --template=dcaas \
    -p POSTGRES_PASSWORD="guac_pass" \
    -p GUACADMIN_PASSWORD="guacadmin"
```

**Step 4. Connect to the route**

Browse to the route. You can find the route address with:

```bash
oc get route
NAME      HOST/PORT                      PATH      SERVICES   PORT      TERMINATION
rdp       mydaac.apps.ocp.example.com    daac       <all>     edge          None
```

Browse to: https://mydaac.apps.ocp.example.com

## HowTo Run in Locally

You can run the container locally via the command below. You need a minimum of 3 containers. The broker wont work, as it requires and OpenShift cluster to create services, routes and spin up desktop containers.

### Build Local Containers

docker build -f Dockerfiles/guac.dockerfile -t guac .
docker build -f Dockerfiles/guacd.dockerfile -t guacd .
docker build -f Dockerfiles/desktop.dockerfile -t gdesk .
docker build -f Dockerfiles/pgsql.dockerfile -t pgsql .

### Run and Link Docker Files

export XRDP_PASSWORD='KL3ECRd9dd68xFsZ'

export GUACD_HOSTNAME='guacd'
export GUACD_PORT='4822'

export POSTGRES_HOST='127.0.0.1'

export POSTGRES_USER='guac'
export POSTGRES_PASSWORD='guac_pass'
export POSTGRES_DATABASE='guacamole_db'

docker run --name desktop \
    -e XRDP_PASSWORD=${XRDP_PASSWORD} \
    -d -p 3389:3389 desktop

docker run --name guacd --link desktop:desktop \
    -d -p 4822:4822 guacd

docker run --name postgres \
    -e POSTGRESQL_USER=${POSTGRES_USER} \
    -e POSTGRESQL_PASSWORD=${POSTGRES_PASSWORD} \
    -e POSTGRESQL_DATABASE=${POSTGRES_DATABASE} \
    -d -p 5432:5432 registry.redhat.io/rhscl/postgresql-96-rhel7

docker run --name guac --link guacd:guacd \
    --link postgres:postgres \
    -e POSTGRES_DATABASE=${POSTGRES_DATABASE}  \
    -e POSTGRES_USER=${POSTGRES_USER}    \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -e GUACD_HOSTNAME=${GUACD_HOSTNAME} \
    -e GUACD_PORT=${GUACD_PORT} \
    -d -p 8080:8080 guac

docker run --name guac-api --link postgres:postgres \
    -e POSTGRES_DATABASE=${POSTGRES_DATABASE}  \
    -e POSTGRES_USER=${POSTGRES_USER}    \
    -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
    -d -p 8080:8080 guac

Browse to: http://127.0.0.1:8080/

## License

GNU General Public License v3.0

See [COPYING](COPYING) to see the full text. 

### WebSite

https://snowjet.github.io/DaaC/