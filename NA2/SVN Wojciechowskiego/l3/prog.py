#!/usr/bin/python

import sys

lines = []
prompt = "write lines: \n"
sys.stdout.write(prompt)
a = sys.stdin.readline(4096)
b = sys.stdin.readline(4096)
c = int(a,16) + int(b,16)
prompt = "\naddition: "
print prompt
print a[:-1]
print b[:-1]
print "+"
print "0x{:0x}".format(c)
print ""

