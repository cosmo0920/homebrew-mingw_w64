Homebrew Mingw-w64 Formulae
===

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

### installing gcc, binutils, and mingw version

* gcc 4.9.3
* binutils 2.25.1
* mingw 4.0.4

### LICENSE

[MIT](LICENSE.txt).
