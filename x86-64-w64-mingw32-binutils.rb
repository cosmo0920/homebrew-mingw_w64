class X8664W64Mingw32Binutils < Formula
  desc "Binutils for minimalist GNU for Windows."
  homepage "https://mingw-w64.org"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.26.1.tar.bz2"
  sha256 "39c346c87aa4fb14b2f786560aec1d29411b6ec34dce3fe7309fe3dd56949fd8"
  revision 1

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
      --prefix=#{libexec}
    ]

    system "./configure", *args
    system "make"
    system "make", "install-strip"

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
