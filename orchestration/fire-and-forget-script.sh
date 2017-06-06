#!/bin/bash

OUT='/vagrant'
if [[ ! -d $OUT ]]; then
  OUT='/tmp'
fi

for i in {1..60} 
do
  echo "This is line $i" >> "$OUT/result.txt"
  sleep 1
done
