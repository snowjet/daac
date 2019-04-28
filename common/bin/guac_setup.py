#!/usr/bin/env python
from xml.etree import ElementTree as et
from os import environ
import argparse

"""
Set these environment variables to update the guacamole user-mapping file
    guac_username = "user"
    guac_password_hash = "5f4dcc3b5aa765d61d8327deb882cf99" <- hash of "password"
    guac_password_encoding="md5"
"""

parser = argparse.ArgumentParser()
parser.add_argument("--vnc_pass", default="")
parser.add_argument("--user_mapping", default="/usr/share/tomcat/.guacamole/user-mapping.xml")
args, unknown_args = parser.parse_known_args()

# Set to defaults if env vars are not set
if environ.get('guac_username'):
    guac_username =  environ['guac_username']
else:
    guac_username = "user"

if environ.get('guac_password_hash'):
    guac_password_hash = environ['guac_password_hash']
else:
    guac_password_hash = "5f4dcc3b5aa765d61d8327deb882cf99"

if environ.get('guac_password_encoding'):
    guac_password_encoding = environ['guac_password_encoding']
else:
    guac_password_encoding="md5"

# Open original file
tree = et.parse(args.user_mapping)

tree.find('.//authorize').attrib['username'] = guac_username
tree.find('.//authorize').attrib['password'] = guac_password_hash
tree.find('.//authorize').attrib['encoding'] = guac_password_encoding
tree.find("./authorize/connection/param/[@name='password']").text = args.vnc_pass

# et.dump(tree)

# Write back to file
tree.write(args.user_mapping)
