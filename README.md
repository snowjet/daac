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

Import the template fromt he repo:

```bash
cd daac
oc apply -f openshift/daac.yml -n openshift
```

**Step 3. Create the Applicaiton**

Create the application from the imported template. Note you need to provide a password hash for the login. 'echo -n <password> | md5sum' will provide an insecure md5 hash'

```bash
oc new-app --name mydaac --template=daac \
    -p guac_username="user" \
    -p guac_password_hash="password as a hash" \
    -p DAAC_IMAGE_NAME="locaiton of the container image"
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

You can run the container locally via the command below. Note you need to provide a password hash for the login. 'echo -n <password> | md5sum' will provide an insecure md5 hash'

```bash
podman run -p 8080:8080 --dns 8.8.8.8 -d  \
    -e guac_username="user" \
    -e guac_password_hash="password as a hash" \
    localhost/html5
```

Browse to: http://127.0.0.1:8080/

## License

GNU General Public License v3.0

See [COPYING](COPYING) to see the full text. 

### WebSite

https://snowjet.github.io/DaaC/