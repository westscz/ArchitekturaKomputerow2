#!/usr/bin/python2.7

import sys

with open(sys.argv[1], 'r') as f:
    for line in f.readlines():
        sys.stdout.write(line)
