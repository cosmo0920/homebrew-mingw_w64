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
    - install mingw-w64 cross gcc and its runtime
* (i686|x86-64)-w64-mingw32-winpthread
    - install mingw-winpthread

### install dir

These formula tries to install mingw-w64 toolchain into each of `#{prefix}`.

You can use these formulae's binaries via Homebrew mechanism as follows:

```ruby
class SomethingMingwBuilding < Formula
  homepage "http://<something>"
  url "<source location>"
  sha256 "<put shasum256>"

  depends_on "cosmo0920/mingw_w64/i686-w64-mingw32-binutils" => :build
  depends_on "cosmo0920/mingw_w64/i686-w64-mingw32-gcc" => :build
  depends_on "cosmo0920/mingw_w64/i686-w64-mingw32-winpthread" => :build

  def install
    args = %W[
      CC=i686-w64-mingw32-gcc
      CXX=i686-w64-mingw32-g++
      CPP=i686-w64-mingw32-cpp
      --host=#{target_arch}
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make"
    system "make install-strip"
  end
end
```

## installing gcc, binutils, and mingw versions

* gcc 4.9.3
* binutils 2.25.1
* mingw 4.0.4

### LICENSE

[MIT](LICENSE.txt).
