# KRET - The Mole

Port of the game from PC to Atari 8-bit.

Arcade and logic game.

You play the role of Stefan the mole, who through his blindness ended up in a warehouse full of packages. Because of his clumsiness he has to be careful not to let the packages crush him.

The creators of the original are Andrzej Baka and Mariusz Buras. They wrote the game in 1991.

# RUN

To run, you will need an ATARI emulator, or real hardware and software that allows you to load the compiled program.

If you have: **MIDICar**, **MIDIBox** or **MIDIMate**, before starting the game, first load from the `\MIDI.DRV` directory one of the drivers intended for your MIDI interface. Only after this, load the game, for ex.:

```
MIDICAR.DRV
KRET.EXE
```

# COMPILE
You will need the MAD Pascal compiler and MADS Assembler.

```
mp kret.pas -o:kret.a65 -code:2180
mads kret.a65 -x -o:kret.xex
```
# CREDITS

Would you like to be a part of this project?
Support it:

- [donate on Patreon](https://www.patreon.com/GSoftDev/membership)
- [submit ideas](https://github.com/GSoftwareDevelopment/Mole/issues)
- [report bugs or corrections to the code](https://github.com/GSoftwareDevelopment/Mole/issues)
- improve the code
- you can also [Discuss about this project](https://github.com/GSoftwareDevelopment/Mole/discussions)

Take action, don't sit idle. Show that you can and you want to be useful. Everyone knows something.

# If you like this...

[![ByMeCaffee](../../../GSoftwareDevelopment/raw/main/bmc.png)](https://www.buymeacoffee.com/PeBe)

# LICENCE

The MIT License (MIT)
Copyright © 2021 GSD

Permission is hereby granted, free of charge,
to any person obtaining a copy of this software
and associated documentation files (the “Software”),
to deal in the Software without restriction,
including without limitation the rights to
use, copy, modify, merge, publish, distribute,
sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice
shall be included in all copies or substantial portions of
the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF
ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR
A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
