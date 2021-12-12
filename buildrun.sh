#!/bin/bash
export PATH="/home/pebe/Atari/MadPascal:$PATH"
mp kret.pas -o
mads kret.a65 -x -t -l -i:/home/pebe/Atari/MadPascal/base -o:kret.xex
wine c:/Altirra/Altirra kret.xex
