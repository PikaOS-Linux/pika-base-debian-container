#! /bin/python3

import os, errno
import json
import subprocess

_APT_CONFIG_PIN="""Package:{PACKAGES}
Pin: release a=experimental   
Pin-Priority: 600
"""

def silentremove(filename):
    try:
        os.remove(filename)
    except OSError as e: # this would be "except OSError, e:" before Python 2.6
        if e.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occurred    

current_path = os.path.dirname(os.path.realpath(__file__))

srcnames_files = [open(current_path + "/package_srcnames/" + filename) for filename in  os.listdir(current_path + "/package_srcnames/")]
srcname_lines = []
pkgname_lines = []
for file in srcnames_files:
    for line in file.readlines():
        srcname = line.strip()
        srcname_lines.append(srcname)
        result = subprocess.run([current_path + "/apt_experiments", '-n', srcname], stdout=subprocess.PIPE)
        stdout = result.stdout
        pkgname_lines.append(stdout)
        pkgname_lines.append(stdout + "t64")
    file.close()

with open (current_path + "/package_pkgnames_overrides") as file:
    lines = file.readlines()
    for line in lines:
        pkgname_lines.append(line.strip())
    file.close()

src_data = {
    'source_names': [source_name for source_name in srcname_lines],
}

pkg_data = {
    'package_names': [pkg_name for pkg_name in pkgname_lines]
}

apt_pin_packages = ""

for pkg in pkgname_lines:
    apt_pin_packages += (" " + pkg)

silentremove("0-debian-exp-overrides")
with open("0-debian-exp-overrides", "w") as file:
    debian_exp_override_file = _APT_CONFIG_PIN.format(
        PACKAGES=apt_pin_packages,
    )
    file.write(debian_exp_override_file)

silentremove("exp_src_names.json")
with open("exp_src_names.json", "w") as twitterDataFile:
    twitterDataFile.write(
        json.dumps(src_data, indent=4)
    )

silentremove("exp_pkg_names.json")
with open("exp_pkg_names.json", "w") as twitterDataFile:
    twitterDataFile.write(
        json.dumps(pkg_data, indent=4)
    )
    