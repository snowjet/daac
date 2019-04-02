# Install OC client

if [[ ! -z $OC_DEV_TOOLS  ]]; then
    curl -L https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz | tar xz
    mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin
    mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/kubectl /usr/local/bin
    rm -rf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit

    curl -L https://github.com/openshift/odo/releases/download/v0.0.20/odo-linux-amd64 --output /usr/local/bin/odo
    chmod +x /usr/local/bin/odo

    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    yum check-update
    yum install -y code

    yum autoremove -y
    yum clean all
fi