#!/bin/sh

TARGET=hsoy-templates.md
rm $TARGET
cp hsoy-templates.base $TARGET
echo '\n' >> $TARGET

BASE=~/Projects/hsoy-templates/docs

for f in $BASE/*.md
do
  echo File: $f
  echo "$f" | sed -E 's#.+/[0-9]{1,2} (.+)\.md#\1#' >> $TARGET
  echo "==============\n" >> $TARGET
  cat "$f" >> $TARGET
  echo '\n' >> $TARGET
done
