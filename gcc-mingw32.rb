require "formula"

class GccMingw32 < Formula
  homepage "http://mingw-w64.sourceforge.net/"
  url "ftp://gcc.gnu.org/pub/gcc/releases/gcc-4.8.3/gcc-4.8.3.tar.bz2"
  sha256 "6a8e4f11b185f4fe2ed9d7fc053e80f8c7e73f800c045f51f9d8bea33f080f1e"

  depends_on "gcc48" => :build
  depends_on "gmp4"
  depends_on "mpfr2"
  depends_on "libmpc08"
  depends_on "cloog018"
  depends_on "isl011"
  depends_on "cosmo0920/mingw_w64/binutils-mingw32"
  depends_on "cosmo0920/mingw_w64/mingw-headers32"

  def install
    install_prefix="/usr/local/mingw/"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = i686-w64-mingw32

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      rmdir "mingw" if Dir.exist?("mingw")
      system "ln -s #{target_arch} mingw"
    end

    version_suffix = version.to_s.slice(/\d\.\d/)

    args = %W[
      CC=gcc-4.8
      CXX=g++-4.8
      CPP=cpp-4.8
      LD=gcc-4.8
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
      --program-suffix=-#{version_suffix}
      --with-gmp=#{Formula["gmp4"].opt_prefix}
      --with-mpfr=#{Formula["mpfr2"].opt_prefix}
      --with-mpc=#{Formula["libmpc08"].opt_prefix}
      --with-cloog=#{Formula["cloog018"].opt_prefix}
      --with-isl=#{Formula["isl011"].opt_prefix}
    ]

    mkdir "build32" do
      system "../configure", *args
      system "make all-gcc"
      system "make install-gcc"
    end
    # restore PATH
    ENV["PATH"] = path
  end

end
