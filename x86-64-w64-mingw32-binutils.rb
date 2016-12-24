class X8664W64Mingw32Binutils < Formula
  desc "Binutils for minimalist GNU for Windows."
  homepage "https://mingw-w64.org"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.26.1.tar.bz2"
  sha256 "39c346c87aa4fb14b2f786560aec1d29411b6ec34dce3fe7309fe3dd56949fd8"
  revision 2

  depends_on "gcc6" => :build

  def install
    target_arch = "x86_64-w64-mingw32"
    args = %W[
      CC=gcc-6
      CXX=g++-6
      CPP=cpp-6
      LD=gcc-6
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

  test do
    assert_match version.to_s, shell_output("#{bin}/x86_64-w64-mingw32-ld --version")
  end
end
