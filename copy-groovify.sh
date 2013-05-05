#!/bin/sh

TARGET=appengine-groovify.md
rm $TARGET
cp appengine-groovify.base $TARGET
echo '\n' >> $TARGET

BASE=~/Projects/groovify-appengine/docs

for f in $BASE/*.md
do
  echo File: $f
  echo "$f" | sed -E 's#.+/[0-9]{1,2} (.+)\.md#\1#' >> $TARGET
  echo "==============\n" >> $TARGET
  cat "$f" >> $TARGET
  echo '\n' >> $TARGET
done