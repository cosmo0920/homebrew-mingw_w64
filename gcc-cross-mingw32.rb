require "formula"

class GccCrossMingw32 < Formula
  homepage "http://gcc.gnu.org"
  url "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.8.3/gcc-4.8.3.tar.bz2"
  sha256 "6a8e4f11b185f4fe2ed9d7fc053e80f8c7e73f800c045f51f9d8bea33f080f1e"

  depends_on "gcc48" => :build
  depends_on "cosmo0920/mingw_w64/gcc-mingw32"


  def install
    install_prefix="/usr/local/mingw/"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = "i686-w64-mingw32"

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      system "rm mingw" if Dir.exist?("mingw")
      system "ln -s #{target_arch} mingw"
    end

    args = %W[
      CC=i686-w64-mingw32-gcc
      CXX=i686-w64-mingw32-g++
      CPP=i686-w64-mingw32-cpp
      LD=i686-w64-mingw32-gcc
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
      --with-gmp=#{Formula["gmp4"].opt_prefix}
      --with-mpfr=#{Formula["mpfr2"].opt_prefix}
      --with-mpc=#{Formula["libmpc08"].opt_prefix}
      --with-cloog=#{Formula["cloog018"].opt_prefix}
      --with-isl=#{Formula["isl011"].opt_prefix}
    ]

    mkdir "build32" do
      system "../configure", *args
      system "make all"
      system "make install"
    end
    # restore PATH
    ENV["PATH"] = path
  end

end
