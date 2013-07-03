#!/bin/bash
for file in `ls OPTdata*/Images/*/*/*/*.hdr`
do
    echo $file
    newname=$(echo $file | sed -e s#/[^/]*hdr#/Stack.hdr#) 
    mv $file $newname
done

for file in `ls OPTdata*/Images/*/*/*/*.img`
do
    echo $file
    newname=$(echo $file | sed -e s#/[^/]*img#/Stack.img#) 
    mv $file $newname
done
