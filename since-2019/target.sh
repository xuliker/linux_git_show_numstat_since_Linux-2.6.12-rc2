#!/bin/bash

# https://tool.chinaz.com/tools/unixtime.aspx
cat part*.txt | awk '$1 >= 1546272000 {print $1" "$2" "$3" "$4" "$5" "$6}' | wc -l
