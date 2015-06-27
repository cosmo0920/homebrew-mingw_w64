require "formula"

class BinutilsMingw32 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.24.tar.bz2"
  sha256 "e5e8c5be9664e7f7f96e0d09919110ab5ad597794f5b1809871177a0f0f14137"

  depends_on "gcc48" => :build

  def install
    install_prefix="/usr/local/mingw"
    args = %W[
      CC=gcc-4.8
      CXX=g++-4.8
      CPP=cpp-4.8
      LD=gcc-4.8
      --target=i686-w64-mingw32
      --disable-werror
      --disable-multilib
      --prefix=#{install_prefix}
      --with-sysroot=#{install_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make install-strip"
  end

end
