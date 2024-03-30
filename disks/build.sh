#!/bin/bash -e

rm -rf cpm*.dsk
for pth in images/*
do
    drive="${pth: -1}"
    image_name="cpm$drive.dsk"
    cp template.dsk $image_name
    echo "Working with drive image: $image_name"
    cpmcp -fnihirash $image_name $pth/*.* 0:
    echo "Image prepared"
done
