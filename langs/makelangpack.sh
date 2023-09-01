#!/bin/bash -x

mads ../data/strings-cz.asm -o:str-cz.obj -d:LANG=EXTERNAL
mads ../data/strings-en.asm -o:str-en.obj -d:LANG=EXTERNAL
mads ../data/strings-pl.asm -o:str-pl.obj -d:LANG=EXTERNAL
mads ../data/strings-de.asm -o:str-de.obj -d:LANG=EXTERNAL

mads ../data/scroll-cz.asm -o:scl-cz.obj -d:LANG=EXTERNAL
mads ../data/scroll-en.asm -o:scl-en.obj -d:LANG=EXTERNAL
mads ../data/scroll-pl.asm -o:scl-pl.obj -d:LANG=EXTERNAL
mads ../data/scroll-de.asm -o:scl-de.obj -d:LANG=EXTERNAL

# wine cmd.exe /c compress.bat

rm *.zx5

./zx5 ../data/letters-cz.fnt letters-cz.zx5
./zx5 ../data/letters-de.fnt letters-de.zx5
./zx5 ../data/letters.fnt letters.zx5

./zx5 ../data/title-b-cz.fnt title-b-cz.zx5
./zx5 ../data/title-b-de.fnt title-b-de.zx5
./zx5 ../data/title-b.fnt title-b.zx5

./zx5 scl-cz.obj scl-cz.zx5
./zx5 scl-en.obj scl-en.zx5
./zx5 scl-pl.obj scl-pl.zx5
./zx5 scl-de.obj scl-de.zx5

./zx5 str-cz.obj str-cz.zx5
./zx5 str-en.obj str-en.zx5
./zx5 str-pl.obj str-pl.zx5
./zx5 str-de.obj str-de.zx5
