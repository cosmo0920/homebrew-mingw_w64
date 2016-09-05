class I686W64Mingw32Gcc < Formula
  desc "Minimalist GNU for Windows with GCC."
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gcc/gcc-4.9.3/gcc-4.9.3.tar.bz2"
  sha256 "2332b2a5a321b57508b9031354a8503af6fdfb868b8c1748d33028d100a8b67e"
  revision 2

  depends_on "gcc49" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "cloog018"
  depends_on "isl012"
  depends_on "cosmo0920/mingw_w64/i686-w64-mingw32-binutils" => :build

  resource "mingw-headers" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.6.tar.bz2"
    sha256 "0c407394b0d8635553f4fbca674cdfe446aac223e90b4010603d863e4bdd015c"
  end

  resource "gcc-core" do
    url "https://ftpmirror.gnu.org/gcc/gcc-4.9.3/gcc-4.9.3.tar.bz2"
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

  def install
    target_arch = "i686-w64-mingw32"

    resource("mingw-headers").stage do
      install_prefix = "#{libexec}/#{target_arch}"
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

      chdir install_prefix.to_s do
        rm "mingw" if Dir.exist?("mingw")
        ln_s install_prefix.to_s, "#{libexec}/mingw"
      end
    end

    resource("gcc-core").stage do
      args = %W[
        CC=gcc-4.9
        CXX=g++-4.9
        CPP=cpp-4.9
        LD=gcc-4.9
        --target=#{target_arch}
        --prefix=#{libexec}
        --disable-multilib
        --disable-nls
        --with-system-zlib
        --enable-version-specific-runtime-libs
        --enable-libstdcxx-time=yes
        --enable-stage1-checking
        --enable-checking=release
        --enable-lto
        --enable-threads=win32
        --disable-sjlj-exceptions
        --enable-languages=c,c++,objc,obj-c++
        --with-gnu-as
        --with-gnu-ld
        --with-ld=#{Formula["i686-w64-mingw32-binutils"].opt_bin/"i686-w64-mingw32-ld"}
        --with-as=#{Formula["i686-w64-mingw32-binutils"].opt_bin/"i686-w64-mingw32-as"}
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

    ENV.prepend_path "PATH", "#{libexec}/bin"

    resource("mingw-runtime").stage do
      args = %W[
        CC=#{target_arch}-gcc
        CXX=#{target_arch}-g++
        CPP=#{target_arch}-cpp
        LD=#{target_arch}-gcc
        --host=#{target_arch}
        --prefix=#{libexec}/#{target_arch}
        --disable-lib64 --enable-lib32
      ]

      chdir "mingw-w64-crt" do
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    end

    # build cross gcc
    args = %W[
      CC=gcc-4.9
      CXX=g++-4.9
      CPP=cpp-4.9
      LD=gcc-4.9
      --target=#{target_arch}
      --prefix=#{libexec}
      --disable-multilib
      --disable-nls
      --with-system-zlib
      --enable-version-specific-runtime-libs
      --enable-libstdcxx-time=yes
      --enable-stage1-checking
      --enable-checking=release
      --enable-lto
      --enable-threads=win32
      --disable-sjlj-exceptions
      --enable-languages=c,c++,objc,obj-c++
      --with-gnu-as
      --with-gnu-ld
      --with-ld=#{Formula["i686-w64-mingw32-binutils"].opt_bin/"i686-w64-mingw32-ld"}
      --with-as=#{Formula["i686-w64-mingw32-binutils"].opt_bin/"i686-w64-mingw32-as"}
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

    chdir "#{libexec}/#{target_arch}/lib" do
      ln_s "../../lib/gcc/#{target_arch}/lib/libgcc_s.a", "./"
    end

    resource("mingw-winpthread").stage do
      ENV["LDPATH"] = "#{target_arch}/#{lib}"
      args = %W[
        CC=i686-w64-mingw32-gcc
        CXX=i686-w64-mingw32-g++
        CPP=i686-w64-mingw32-cpp
        --host=#{target_arch}
        --prefix=#{libexec}/#{target_arch}
      ]

      chdir "mingw-w64-libraries/winpthreads" do
        system "./configure", *args
        system "make"
        system "make", "install-strip"
      end
    end

    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
