#!/bin/bash

low=$(echo "$1-5" | bc -l)
upp=$(echo "$1+5" | bc -l)

lmake << EOF

$low
$upp
y
y
y
y
y
y

EOF

mv outsort $1.lin
rm outlines
