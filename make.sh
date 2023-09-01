#!/bin/bash -x

mpc build kret.pas -code:2180

cd langs
./makelangpack.sh
cd ..

mp lang.pas -o:bin/lang.a65 -code:2180
sed -i 's/run START/ini START/' bin/lang.a65
mads bin/lang.a65 -x -i:/home/pebe/Atari/MadPascal/base -o:bin/lang.xex

cd bin
rm kret.exe
cat lang.xex kret.xex >> kret.exe
cd ..

echo "Tadam"
