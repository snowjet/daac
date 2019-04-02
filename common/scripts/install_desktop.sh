# Based on the BUILD ARG install one of the following desktops
# ARG DESKTOP

case $DESKTOP in
     gnome3)
            echo "Installing Gnome 3 Destop"
            yum install -y gnome-classic-session gnome-session gnome-terminal nautilus-open-terminal control-center liberation-mono-fonts
            echo "PREFERRED=/usr/bin/gnome-session --session gnome-classic" > /etc/sysconfig/desktop
          ;;
     mate|*)
            echo "Installing Mate Destop"
            yum --setopt=group_package_types=mandatory groupinstall -y "Mate Desktop"
            yum install -y adapta-gtk-theme liberation-mono-fonts mate-terminal
            echo "PREFERRED=/usr/bin/mate-session" > /etc/sysconfig/desktop

cat << EOF > /etc/dconf/db/local.d/00_mate_desktop
[mate/desktop/interface]
icon-theme='Numix'
gtk-theme='Numix'
EOF

cat << EOF > /etc/dconf/db/local.d/locks/00_mate_desktop
# Mate Themes
/org/mate/desktop/interface/icon-theme
/org/mate/desktop/interface/gtk-theme
EOF

dconf update
          ;;
esac

yum autoremove -y
yum clean all