#!/usr/bin/env python
import argparse
import subprocess, os, sys
import logging
from time import sleep

logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)

"""
Expecting the following from xrdp-sesman
Xvnc :10 -auth .Xauthority -geometry 892x948 -depth 16 -rfbauth  -bs -nolisten tcp -localhost -dpi 96
"""

parser = argparse.ArgumentParser()
parser.add_argument("-auth")
parser.add_argument("-geometry")
parser.add_argument("-depth")
parser.add_argument("-dpi")
parser.add_argument(":")
args, unknown_args = parser.parse_known_args()

display_env = os.environ.copy()
display_env["DISPLAY"] = ":10"
display_env["HOME"] = "/home/user"

logging.debug('Commands Received:' + str(args) + str(unknown_args))

xvnc_cmd = "/usr/bin/vncserver :10 -name user -geometry %s \
            -depth %s -noxstartup -auth .Xauthority -bs \
            -nolisten tcp -localhost -dpi 96 -SecurityTypes None" %(args.geometry, args.depth)

logging.debug("Starting XVNC with: " + xvnc_cmd)
xvnc = subprocess.Popen(xvnc_cmd, shell=True, cwd="/home/user",
                        env=display_env, stderr=subprocess.PIPE, 
                        stdout=subprocess.PIPE)

# sesman will automatically kill this process from here.