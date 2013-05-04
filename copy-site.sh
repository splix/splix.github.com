#!/bin/sh

cp -f _site/*.html ../

rm -rf ../css
rm -rf ../images
rm -rf ../js

cp -R _site/css ../
cp -R _site/images ../
cp -R _site/js ../

