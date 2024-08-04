#! /bin/python3

import os, errno
import json
import subprocess
import apt
import numpy as np
import threading

def silentremove(filename):
    try:
        os.remove(filename)
    except OSError as e: # this would be "except OSError, e:" before Python 2.6
        if e.errno != errno.ENOENT: # errno.ENOENT = no such file or directory
            raise # re-raise exception if a different error occurred    

def pharse_build_tree(pkg_arr, current_path, pkgname_lines):
    for pkgname in pkg_arr:
        print("Parsing dep tree for: " + pkgname)
        result = subprocess.run([current_path + '/get_depend_tree.sh', pkgname], stdout=subprocess.PIPE)
        stdout = result.stdout.decode('utf-8')
        for line in stdout.splitlines():
                if line != "":
                    pkgname_lines.append(line)

current_path = os.path.dirname(os.path.realpath(__file__))

whitelist_arr = np.array([])
thread_arr = []
pkgname_lines = []
srcname_lines = []
srcnames_clean = []
file = open(current_path + "/i386_whitelist_bins", "r")

for line in file.readlines():
    pkgname = line.strip()
    if pkgname != "" and not pkgname.endswith("-udeb"):
        pkgname_lines.append(pkgname)
        np.append(whitelist_arr, pkgname)
file.close()

newarr = np.array_split(whitelist_arr, 8)

for array in newarr:
    t0 = threading.Thread(target=pharse_build_tree, args=(array, current_path, pkgname_lines,))
    thread_arr.append(t0)
    
for thread_proc in thread_arr:
    thread_proc.start()

for thread_proc in thread_arr:
    thread_proc.join()

c = apt.Cache()

for pkgname in pkgname_lines:
    try:
        src_name = c[pkgname].candidate.source_name
        if src_name:
            srcname_lines.append(src_name)
    except:
        pass

for i in srcname_lines:
  if i not in srcnames_clean and i + "-dmo" not in srcnames_clean:
    srcnames_clean.append(i)

src_data = {
    'i386_whitelist': [source_name for source_name in srcnames_clean],
}


silentremove("i386_src_whitelist.json")
with open("i386_src_whitelist.json", "w") as twitterDataFile:
    twitterDataFile.write(
        json.dumps(src_data, indent=4)
    )
