# Based on the BUILD ARG install one of the following desktops
# ARG DESKTOP

case $DESKTOP in
     gnome3)
            echo "Installing Gnome 3 Destop"
            yum install -y gnome-classic-session gnome-session gnome-terminal nautilus-open-terminal control-center
            echo "PREFERRED=/usr/bin/gnome-session --session gnome-classic" > /etc/sysconfig/desktop
          ;;
     mate)
            echo "Installing Mate Destop"
            yum --setopt=group_package_types=mandatory groupinstall -y "Mate Desktop"
            yum install -y numix-gtk-theme numix-icon-theme mate-terminal
            echo "PREFERRED=/usr/bin/mate-session" > /etc/sysconfig/desktop

            cp /tmp/config/dconf/00_mate_theme /etc/dconf/db/local.d/
            dconf update
          ;;
     xfce|*)
            echo "Installing XFCE Destop"
            yum -y groupinstall "X Window system"
            yum -y groupinstall --setopt=group_package_types=mandatory xfce
            echo "PREFERRED=/usr/bin/startxfce4" > /etc/sysconfig/desktop
          ;;
esac

yum install -y liberation-fonts

# Reduce the image size
# yum remove -y  mate-backgrounds avahi

# END