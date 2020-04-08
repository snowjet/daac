# DCaaS - Desktop Container as a Service

## Goal

Create a Container Based VDI system running on OpenShift.

**Key Features:**

* Runs a graphical desktop ontop of OpenShift with default security controls
* OpenShift creates a random local user account for the desktop to exist within
* Uses Guacamole for the HTML5 Proxy
* XRDP is used to spawn the desktop. XRDP allows the desktop match the size of the current window. WHich means if you full screen your browser when logging in you will have a full screen desktop.
* Build a desktop on Mate (recommended), Gnome3 or XFCE

## DCaaS Run Demo

!['DCaaS Run Demo'](./demo/daac-run.gif)

## Howto Run in OpenShift

The easiest way to get started is to use Code Ready Containers and use daac-ansible: https://github.com/snowjet/daac-ansible

Once deployed just browse to: https://daac.apps-crc.testing

![Demo Deploying Daac](./demo/daac-ansible.svg)

## Howto Build Containers Manually

**Build Arguments**

| Argument | Description                   | Value                  |
|----------|:------------------------------|:-----------------------|
| DESKTOP  | Selected Main Desktop Session | mate, gnome3 or xfce]  |
| OC_DEV_TOOLS | Install OpenShift Developer Tools | True or False  |

**Buildah Build**
```bash
buildah bud -f dockerfiles/guac.dockerfile -t guac .
buildah bud -f dockerfiles/guacd.dockerfile -t guacd .
buildah bud -f dockerfiles/desktop.dockerfile -t gdesk .
```

## Requirements

The daac-broker makes the assumption that all use exist in Auth0. You need to setup an Auth0 account and add the following settings under your application:

| Argument               | Setting                                                                                                  |
|------------------------|:---------------------------------------------------------------------------------------------------------|
| Allowed Callback URLs  | https://guac.apps-crc.testing/#/, https://guac.apps-crc.testing/, https://daac.apps-crc.testing/callback | 
| Allowed Logout URLs    | https://daac.apps-crc.testing                                                                            |

You will also need to record the following values and add them to ansible vars when running daac-ansible

* name of the Auth0 App
* domain of the Auth0 App
* client-id
* client-secret


## License

GNU General Public License v3.0

See [COPYING](COPYING) to see the full text. 

### WebSite

https://snowjet.github.io/DaaC/