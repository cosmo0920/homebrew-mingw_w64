class X8664W64Mingw32Gcc < Formula
  desc "Minimalist GNU for Windows with GCC."
  homepage "https://gcc.gnu.org"
  url "http://ftpmirror.gnu.org/gcc/gcc-4.9.3/gcc-4.9.3.tar.bz2"
  sha256 "2332b2a5a321b57508b9031354a8503af6fdfb868b8c1748d33028d100a8b67e"
  revision 1

  resource "mingw-headers" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.6.tar.bz2"
    sha256 "0c407394b0d8635553f4fbca674cdfe446aac223e90b4010603d863e4bdd015c"
  end

  resource "gcc-core" do
    url "http://ftpmirror.gnu.org/gcc/gcc-4.9.3/gcc-4.9.3.tar.bz2"
    sha256 "2332b2a5a321b57508b9031354a8503af6fdfb868b8c1748d33028d100a8b67e"
  end

  resource "mingw-runtime" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.6.tar.bz2"
    sha256 "0c407394b0d8635553f4fbca674cdfe446aac223e90b4010603d863e4bdd015c"
  end

  resource "mingw-winpthread" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.6.tar.bz2"
    sha256 "0c407394b0d8635553f4fbca674cdfe446aac223e90b4010603d863e4bdd015c"
  end

  keg_only <<-EOS.undent
    This formula is mainly used internally by other formulae.
EOS

  depends_on "gcc49" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "cloog018"
  depends_on "isl012"
  depends_on "cosmo0920/mingw_w64/x86-64-w64-mingw32-binutils" => :build

  def install
    target_arch = "x86_64-w64-mingw32"

    resource("mingw-headers").stage do
      install_prefix = "#{prefix}/#{target_arch}"
      args = %W[
        --host=#{target_arch}
        --prefix=#{install_prefix}
        --enable-sdk=all
        --enable-secure-api
      ]

      mkdir "build-headers" do
        system "../mingw-w64-headers/configure", *args
        system "make"
        system "make", "install"
      end

      # create symlink to `#{prefix}//mingw/include`
      chdir install_prefix.to_s do
        rm "mingw" if Dir.exist?("mingw")
        ln_s "#{prefix}/#{target_arch}", "#{prefix}/mingw"
      end
    end

    resource("gcc-core").stage do
      args = %W[
        CC=gcc-4.9
        CXX=g++-4.9
        CPP=cpp-4.9
        LD=gcc-4.9
        --target=#{target_arch}
        --prefix=#{prefix}
        --disable-multilib
        --disable-nls
        --with-system-zlib
        --enable-version-specific-runtime-libs
        --enable-libstdcxx-time=yes
        --enable-stage1-checking
        --enable-checking=release
        --enable-lto
        --enable-threads=win32
        --enable-languages=c,c++,objc,obj-c++
        --with-gnu-as
        --with-gnu-ld
        --with-ld=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-ld"}
        --with-as=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-as"}
        --with-gmp=#{Formula["gmp4"].opt_prefix}
        --with-mpfr=#{Formula["mpfr2"].opt_prefix}
        --with-mpc=#{Formula["libmpc08"].opt_prefix}
        --with-cloog=#{Formula["cloog018"].opt_prefix}
        --with-isl=#{Formula["isl012"].opt_prefix}
        MAKEINFO=missing
      ]

      mkdir "build32" do
        system "../configure", *args
        system "make", "all-gcc"
        system "make", "install-gcc"
      end
    end

    resource("mingw-runtime").stage do
      ENV.prepend_path "PATH", bin

      args = %W[
        CC=#{target_arch}-gcc
        CXX=#{target_arch}-g++
        CPP=#{target_arch}-cpp
        LD=#{target_arch}-gcc
        --host=#{target_arch}
        --prefix=#{prefix}/#{target_arch}
        --disable-lib32 --enable-lib64
      ]

      chdir "mingw-w64-crt" do
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    end

    # build cross gcc
    path = ENV["PATH"]
    ENV.prepend_path "PATH", bin
    args = %W[
      CC=gcc-4.9
      CXX=g++-4.9
      CPP=cpp-4.9
      LD=gcc-4.9
      --target=#{target_arch}
      --prefix=#{prefix}
      --disable-multilib
      --disable-nls
      --with-system-zlib
      --enable-version-specific-runtime-libs
      --enable-libstdcxx-time=yes
      --enable-stage1-checking
      --enable-checking=release
      --enable-lto
      --enable-threads=win32
      --enable-languages=c,c++,objc,obj-c++
      --with-gnu-as
      --with-gnu-ld
      --with-ld=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-ld"}
      --with-as=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-as"}
      --with-gmp=#{Formula["gmp4"].opt_prefix}
      --with-mpfr=#{Formula["mpfr2"].opt_prefix}
      --with-mpc=#{Formula["libmpc08"].opt_prefix}
      --with-cloog=#{Formula["cloog018"].opt_prefix}
      --with-isl=#{Formula["isl012"].opt_prefix}
      MAKEINFO=missing
    ]

    mkdir "build32-cross" do
      system "../configure", *args
      system "make"
      system "make", "install"
    end

    chdir "#{prefix}/#{target_arch}/lib" do
      ln_s "../../lib/gcc/#{target_arch}/lib/libgcc_s.a", "./"
    end

    # restore PATH
    ENV["PATH"] = path

    resource("mingw-winpthread").stage do
      ENV["LDPATH"] = "#{target_arch}/#{lib}"
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
        system "make", "install-strip"
      end
    end
  end
end
