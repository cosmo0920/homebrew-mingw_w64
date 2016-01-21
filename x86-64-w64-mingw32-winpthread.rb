require "formula"

class X8664W64Mingw32Winpthread < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.4.tar.bz2"
  sha256 "89356a0aa8cf9f8b9dc8d92bc8dd01a131d4750c3acb30c6350a406316c42199"

  depends_on "cosmo0920/mingw_w64/x86-64-w64-mingw32-binutils" => :build
  depends_on "cosmo0920/mingw_w64/x86-64-w64-mingw32-gcc" => :build

  keg_only <<-EOS.undent
    This formula is mainly used internally by other formulae.
EOS

  def install
    target_arch="x86_64-w64-mingw32"

    args = %W[
      CC=x86_64-w64-mingw32-gcc
      CXX=x86_64-w64-mingw32-g++
      CPP=x86_64-w64-mingw32-cpp
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
