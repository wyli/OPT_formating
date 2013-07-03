#!/bin/bash
for file in `ls OPTdata*/Images*/*/*/*/*.hdr`
do
    newname=$(echo $file | sed -e s#/[^/]*hdr#/Stack.hdr#) 
    mv $file $newname
done

for file in `ls OPTdata*/Images*/*/*/*/*.img`
do
    newname=$(echo $file | sed -e s#/[^/]*hdr#/Stack.img#) 
    mv $file $newname
done
