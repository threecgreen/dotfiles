#!/bin/sh

rocm-smi  -u -d 0 --csv | awk -F',' 'NR == 3 { print ""$2"%" } '
