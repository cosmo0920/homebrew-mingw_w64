Homebrew Mingw-w64 Formulae
===

## Sub command

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

## Formulae (Deprecated)

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

* binutils-mingw(32|64)
    - install mingw-w64 binutils
* gcc-cross-mingw(32|64)
    - install mingw-w64 cross gcc
* gcc-mingw(32|64)
    - install mingw-w64 gcc-core
* mingw-headers(32|64)
    - install mingw-w64 headers
* rutime-mingw(32|64)
    - install mingw-runtime
* winpthread-mingw(32|64)
    - install mingw-winpthread

### install dir

These formula tries to install mingw-w64 toolchain into `/usr/local/mingw`.

To use mingw-w64 compilers, add PATH into `/usr/local/mingw/bin`.

## installing gcc, binutils, and mingw versions

* gcc 4.9.3
* binutils 2.25.1
* mingw 4.0.4

### LICENSE

[MIT](LICENSE.txt).
