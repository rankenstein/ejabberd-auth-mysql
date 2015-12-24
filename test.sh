#!/bin/bash

PYTHON=${PYTHON:-/usr/bin/python}

echo -n "Python version is: "
"$PYTHON" --version

encode_lines() {
    "$PYTHON" <<EOF
import sys,struct

while True:
    line = sys.stdin.readline().rstrip()
    sys.stdout.write(struct.pack('>h', len(line)))
    sys.stdout.write(line)
    sys.stdout.flush()
EOF
}

decode_lines() {
	"$PYTHON" <<EOF
import sys,struct

while True:
    (size,p) = struct.unpack('>hh', sys.stdin.read(4))
    print(p)
EOF
}

tail -f /var/log/ejabberd/extauth.log &

encode_lines | "$PYTHON" auth_mysql.py | decode_lines