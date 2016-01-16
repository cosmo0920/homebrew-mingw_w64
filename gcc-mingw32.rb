require "formula"

class GccMingw32 < Formula
  homepage "https://gcc.gnu.org"
  url "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.9.3/gcc-4.9.3.tar.bz2"
  sha256 "2332b2a5a321b57508b9031354a8503af6fdfb868b8c1748d33028d100a8b67e"

  depends_on "gcc49" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "cloog018"
  depends_on "isl012"
  depends_on "cosmo0920/mingw_w64/binutils-mingw32"
  depends_on "cosmo0920/mingw_w64/mingw-headers32"

  def install
    install_prefix="#{HOMEBREW_PREFIX}/mingw"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = "i686-w64-mingw32"

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      rm "mingw" if Dir.exist?("mingw")
      ln_s "#{target_arch}", "mingw"
    end

    args = %W[
      CC=gcc-4.9
      CXX=g++-4.9
      CPP=cpp-4.9
      LD=gcc-4.9
      --target=#{target_arch}
      --prefix=#{install_prefix}
      --with-sysroot=#{install_prefix}
      --disable-multilib
      --with-system-zlib
      --enable-version-specific-runtime-libs
      --enable-libstdcxx-time=yes
      --enable-stage1-checking
      --enable-checking=release
      --enable-lto
      --enable-threads=win32
      --disable-sjlj-exceptions
      --enable-languages=c,c++,objc,obj-c++
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-cloog=#{Formula["cloog018"].opt_prefix}
      --with-isl=#{Formula["isl012"].opt_prefix}
    ]

    mkdir "build32" do
      system "../configure", *args
      system "make all-gcc"
      system "make install-gcc"
    end
    # restore PATH
    ENV["PATH"] = path

    # Suppress empty installation warning
    touch prefix/"no-warning"
  end

end
