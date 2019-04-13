# User local auth
# Set the below vars in ARG within the Dockerfile
# LOCAL_AUTH_USER=""
# LOCAL_AUTH_USER_PWHASH=""

if [[ ! -z $LOCAL_AUTH_USER  ]]; then
    useradd build -u 10001 -g 0 -d /home/${LOCAL_AUTH_USER} --create-home -G wheel --password "${LOCAL_AUTH_USER_PWHASH}"
    chmod 770 /home/${LOCAL_AUTH_USER}
fi