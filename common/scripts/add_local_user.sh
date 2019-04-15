# User local auth
# Set the below vars in ARG within the Dockerfile
# LOCAL_AUTH_USER=""
# LOCAL_AUTH_USER_PWHASH=""

# if [[ ! -z $LOCAL_AUTH_USER  ]]; then
#     mkdir -p /home/${LOCAL_AUTH_USER}
#     chown -R root:root /home/${LOCAL_AUTH_USER}

#     useradd build -u 10001 -g 0 -d /home/${LOCAL_AUTH_USER} -G wheel --password "${LOCAL_AUTH_USER_PWHASH}"

#     chmod 770 /home/${LOCAL_AUTH_USER}
#     chown -R ${LOCAL_AUTH_USER}:0 /home/${LOCAL_AUTH_USER}
#     chmod -R g+rw /etc/passwd

#     sed "s@${LOCAL_AUTH_USER}:x:10001:@${LOCAL_AUTH_USER}:x:10001:@g" /etc/passwd > /etc/passwd.template
# fi

mkdir -p /home/user
chown -R root:root /home/user

useradd user -u 10001 -g 0 -d /home/user -G wheel --password "${LOCAL_AUTH_USER_PWHASH}"

chmod 770 /home/user
chown -R user:0 /home/user
chmod -R g+rw /etc/passwd

sed "s@user:x:10001:@user:x:\${USER_ID}:@g" /etc/passwd > /etc/passwd.template
