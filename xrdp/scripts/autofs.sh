# Install and connect autofs server
# This requires CAP_ADD = SYS_ADMIN
# Set the below vars in ENV within the Dockerfile
# NFS_HOMEDIR_SEVER=""

if [[ ! -z $NFS_HOMEDIR_SEVER  ]]; then
    yum install -y nfs-utils autofs
    echo "/home	/etc/auto.home" > /etc/auto.master.d/home.autofs
    echo "*     -rw,sync	$NFS_HOMEDIR_SEVER:/exports/home/&" > /etc/auto.home
    systemctl enable autofs.service; 
fi