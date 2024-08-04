#!/usr/bin/python3
import sys

import apt

pkgname = sys.argv[1]
c = apt.Cache()
print(c[pkgname].candidate.source_name)

