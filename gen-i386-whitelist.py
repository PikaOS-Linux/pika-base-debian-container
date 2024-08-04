#! /bin/python3

import os, errno
import json
import subprocess
import apt

def silentremove(filename):
    try:
        os.remove(filename)
    except OSError as e: # this would be "except OSError, e:" before Python 2.6
        if e.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occurred    

current_path = os.path.dirname(os.path.realpath(__file__))

pkgname_lines = []
srcname_lines = []
srcnames_clean = []
file = open(current_path + "/i386_whitelist_bins", "r")
for line in file.readlines():
    pkgname = line.strip()
    if pkgname != "" and not pkgname.endswith("-udeb"):
        pkgname_lines.append(pkgname)
        result = subprocess.run([current_path + '/get_depend_tree.sh', pkgname], stdout=subprocess.PIPE)
        stdout = result.stdout.decode('utf-8')
        for line in stdout.splitlines():
                if line != "":
                    pkgname_lines.append(line)
file.close()

c = apt.Cache()

for pkgname in pkgname_lines:
    src_name = c[pkgname].candidate.source_name
    if src_name:
        srcname_lines.append(src_name)

for i in srcname_lines:
  if i not in srcnames_clean:
    srcnames_clean.append(i)

src_data = {
    'i386_whitelist': [source_name for source_name in srcnames_clean],
}


silentremove("i386_src_whitelist.json")
with open("i386_src_whitelist.json", "w") as twitterDataFile:
    twitterDataFile.write(
        json.dumps(src_data, indent=4)
    )
    
