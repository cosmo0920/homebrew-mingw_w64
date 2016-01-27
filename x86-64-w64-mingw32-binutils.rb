class X8664W64Mingw32Binutils < Formula
  desc "Binutils for minimalist GNU for Windows."
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.25.1.tar.bz2"
  sha256 "b5b14added7d78a8d1ca70b5cb75fef57ce2197264f4f5835326b0df22ac9f22"

  keg_only <<-EOS.undent
    This formula is mainly used internally by other formulae.
EOS

  depends_on "gcc49" => :build

  def install
    target_arch = "x86_64-w64-mingw32"
    args = %W[
      CC=gcc-4.9
      CXX=g++-4.9
      CPP=cpp-4.9
      LD=gcc-4.9
      --target=#{target_arch}
      --disable-werror
      --disable-multilib
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install-strip"
  end
end
