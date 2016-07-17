Homebrew Mingw-w64 Formulae
===

## Sub command (Recommended)

Unofficial Homebrew user-defined sub-command.

To use this sub-command:

```bash
$ brew tap cosmo0920/mingw_w64
$ brew tap homebrew/versions
```

and then,

```bash
$ brew install-mingw-w64
```

Finally, you can install `mingw-w64` named keg cellar.
You can uninstall this cellar with `brew uninstall mingw-w64`.

## Formulae

Unofficial Homebrew Mingw-w64 Formulae.

To use these formulae,

```bash
$ brew tap cosmo0920/mingw_w64
$ brew tap homebrew/versions
```

and then,

```bash
$ brew install <mingw_w64 formula>
```
### Contents

* (i686|x86-64)-w64-mingw32-binutils
    - install mingw-w64 binutils
* (i686|x86-64)-w64-mingw32-gcc
    - install mingw-w64 cross gcc and its runtime (winpthread also included)

### install dir

These formulae try to install mingw-w64 toolchain into each of `#{prefix}`.

You can use these formulae's binaries to set PATH like this:

```bash
export PATH=/usr/local/opt/i686-w64-mingw32-binutils/bin:/usr/local/opt/i686-w64-mingw32-gcc/bin:/usr/local/opt/x86-64-w64-mingw32-binutils/bin:/usr/local/opt/x86-64-w64-mingw32-gcc/bin:$PATH
```

## installing gcc, binutils, and mingw versions

* gcc 4.9.3
* binutils 2.26.1
* mingw 4.0.6

### LICENSE

[MIT](LICENSE.txt).
