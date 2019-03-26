# Conenct to IPA for LDAP Auth
# Set the below vars in ENV within the Dockerfile
# IPA_SERVER=""
# LDAP_BASEDN=""

if [[ ! -z $IPA_SERVER  ]]; then
	yum install -y sssd authconfig openldap
    mkdir -p /etc/openldap/cacerts/ 
    wget -O /etc/openldap/cacerts/cert.pem "http://$IPA_SERVER/ipa/config/ca.crt"
    authconfig --enableldap --enableldapauth \
    --ldapserver="$IPA_SERVER" \
    --ldapbasedn="$LDAP_BASEDN" \
    --enableldaptls --enablemkhomedir --update
fi




