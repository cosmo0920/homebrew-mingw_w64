class X8664W64Mingw32Gcc < Formula
  desc "Minimalist GNU for Windows with GCC."
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gcc/gcc-6.2.0/gcc-6.2.0.tar.bz2"
  sha256 "9944589fc722d3e66308c0ce5257788ebd7872982a718aa2516123940671b7c5"
  revision 2

  depends_on "gcc" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "isl@0.14"
  depends_on "cosmo0920/mingw_w64/x86-64-w64-mingw32-binutils" => :build

  resource "mingw-headers" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.6.tar.bz2"
    sha256 "0c407394b0d8635553f4fbca674cdfe446aac223e90b4010603d863e4bdd015c"
  end

  resource "gcc-core" do
    url "https://ftpmirror.gnu.org/gcc/gcc-6.2.0/gcc-6.2.0.tar.bz2"
    sha256 "9944589fc722d3e66308c0ce5257788ebd7872982a718aa2516123940671b7c5"
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
    target_arch = "x86_64-w64-mingw32"

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
        CC=gcc-6
        CXX=g++-6
        CPP=cpp-6
        LD=gcc-6
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
        --enable-languages=c,c++,objc,obj-c++
        --with-gnu-as
        --with-gnu-ld
        --with-ld=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-ld"}
        --with-as=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-as"}
        --with-gmp=#{Formula["gmp"].opt_prefix}
        --with-mpfr=#{Formula["mpfr"].opt_prefix}
        --with-mpc=#{Formula["libmpc"].opt_prefix}
        --with-isl=#{Formula["isl@0.14"].opt_prefix}
        MAKEINFO=#{Formula["texinfo"].opt_bin}/makeinfo
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
        --disable-lib32 --enable-lib64
      ]

      chdir "mingw-w64-crt" do
        system "./configure", *args
        system "make"
        system "make", "install"
      end
    end

    # build cross gcc
    args = %W[
      CC=gcc-6
      CXX=g++-6
      CPP=cpp-6
      LD=gcc-6
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
      --enable-languages=c,c++,objc,obj-c++
      --with-gnu-as
      --with-gnu-ld
      --with-ld=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-ld"}
      --with-as=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-as"}
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl@0.14"].opt_prefix}
      MAKEINFO=#{Formula["texinfo"].opt_bin}/makeinfo
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
        CC=x86_64-w64-mingw32-gcc
        CXX=x86_64-w64-mingw32-g++
        CPP=x86_64-w64-mingw32-cpp
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

  test do
    assert_match version.to_s, shell_output("#{bin}/x86_64-w64-mingw32-gcc --version")
  end
end
