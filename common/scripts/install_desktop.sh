# Based on the BUILD ARG install one of the following desktops
# ARG DESKTOP
case $DESKTOP in
     gnome3)
            echo "Installing Gnome 3 Destop"
            yum install -y gnome-classic-session gnome-session gnome-terminal nautilus-open-terminal control-center
            echo "PREFERRED=/usr/bin/gnome-session --session gnome-classic" > /etc/sysconfig/desktop
          ;;
     mate|*)
            echo "Installing Mate Destop"
            # yum --setopt=group_package_types=mandatory groupinstall -y "Mate Desktop"
            yum install -y caja marco mate-desktop mate-menus mate-session-manager \
                           mate-system-monitor xdg-user-dirs-gtk yelp gtk2-engines mate-terminal mate-panel \
                           mate-polkit mate-settings-daemon
            yum install -y numix-gtk-theme numix-icon-theme 
            echo "PREFERRED=/usr/bin/mate-session" > /etc/sysconfig/desktop

            cp /tmp/config/dconf/00_mate_theme /etc/dconf/db/local.d/
            dconf update
          ;;
     xfce)
            echo "Installing XFCE Destop"
            yum -y groupinstall "X Window system"
            yum -y groupinstall --setopt=group_package_types=mandatory xfce
            echo "PREFERRED=/usr/bin/startxfce4" > /etc/sysconfig/desktop
          ;;
esac

yum install -y liberation-fonts dejavu-sans-mono-font


if [[ ! -z $OC_DEV_TOOLS  ]]; then
    curl -L https://mirror.openshift.com/pub/openshift-v3/clients/3.11.100/linux/oc.tar.gz | tar xz
    mv oc /usr/local/bin

  #    sh -c 'echo -e "[kubernetes]\nname=Kubernetes\nbaseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" > /etc/yum.repos.d/kubernetes.repo'
  #    yum install -y kubectl

    curl -L https://github.com/openshift/odo/releases/download/v0.0.20/odo-linux-amd64 --output /usr/local/bin/odo
    chmod +x /usr/local/bin/odo

    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

    yum check-update
    yum install -y code

    yum autoremove -y
    yum clean all
fi

# Install Useful Tools
yum remove -y git
yum autoremove -y
yum install -y unzip htop wget chromium firefox curl git2u

# END