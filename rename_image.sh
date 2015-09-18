#!/bin/bash
for file in `ls OPTdata*/Images/*/*/*/*.hdr`
do
    echo $file
    newname=$(echo $file | sed -e s#/[^/]*hdr#/Stack.hdr#) 
    echo $newname
    #mv $file $newname
done

for file in `ls OPTdata*/Images/*/*/*/*.img`
do
    echo $file
    newname=$(echo $file | sed -e s#/[^/]*img#/Stack.img#) 
    echo $newname
    #mv $file $newname
done
