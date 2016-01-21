require "formula"

class I686W64Mingw32Winpthread < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.4.tar.bz2"
  sha256 "89356a0aa8cf9f8b9dc8d92bc8dd01a131d4750c3acb30c6350a406316c42199"

  depends_on "cosmo0920/mingw_w64/i686-w64-mingw32-binutils" => :build
  depends_on "cosmo0920/mingw_w64/i686-w64-mingw32-gcc" => :build

  keg_only <<-EOS.undent
    This formula is mainly used internally by other formulae.
EOS

  def install
    target_arch="i686-w64-mingw32"

    args = %W[
      CC=i686-w64-mingw32-gcc
      CXX=i686-w64-mingw32-g++
      CPP=i686-w64-mingw32-cpp
      --host=#{target_arch}
      --prefix=#{prefix}/#{target_arch}
    ]

    chdir "mingw-w64-libraries/winpthreads" do
      system "./configure", *args
      system "make"
      system "make install-strip"
    end
  end
end
