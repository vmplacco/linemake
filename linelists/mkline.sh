#!/bin/bash

for i in $(ls *.lin | sed -e 's/.lin//g')
	do

low=$(echo "$i-15" | bc -l)
upp=$(echo "$i+15" | bc -l)

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

mv outsort $i.lin
rm outlines

done
