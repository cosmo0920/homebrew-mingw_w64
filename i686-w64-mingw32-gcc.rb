class I686W64Mingw32Gcc < Formula
  desc "Minimalist GNU for Windows with GCC."
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
  sha256 "1cf7adf8ff4b5aa49041c8734bbcf1ad18cc4c94d0029aae0f4e48841088479a"

  depends_on "gcc" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "isl"
  depends_on "cosmo0920/mingw_w64/i686-w64-mingw32-binutils" => :build

  conflicts_with "mingw-w64", :because => "homebrew-core has mingw-w64 formula"

  resource "mingw-headers" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.3.tar.bz2"
    sha256 "2a601db99ef579b9be69c775218ad956a24a09d7dabc9ff6c5bd60da9ccc9cb4"
  end

  resource "gcc-core" do
    url "https://ftp.gnu.org/gnu/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
    mirror "https://ftpmirror.gnu.org/gcc/gcc-7.2.0/gcc-7.2.0.tar.xz"
    sha256 "1cf7adf8ff4b5aa49041c8734bbcf1ad18cc4c94d0029aae0f4e48841088479a"
  end

  resource "mingw-runtime" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.3.tar.bz2"
    sha256 "2a601db99ef579b9be69c775218ad956a24a09d7dabc9ff6c5bd60da9ccc9cb4"
  end

  resource "mingw-winpthread" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.3.tar.bz2"
    sha256 "2a601db99ef579b9be69c775218ad956a24a09d7dabc9ff6c5bd60da9ccc9cb4"
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
        CC=gcc-7
        CXX=g++-7
        CPP=cpp-7
        LD=gcc-7
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
        --with-gmp=#{Formula["gmp"].opt_prefix}
        --with-mpfr=#{Formula["mpfr"].opt_prefix}
        --with-mpc=#{Formula["libmpc"].opt_prefix}
        --with-isl=#{Formula["isl"].opt_prefix}
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
      CC=gcc-7
      CXX=g++-7
      CPP=cpp-7
      LD=gcc-7
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
      --with-gmp=#{Formula["gmp"].opt_prefix}
      --with-mpfr=#{Formula["mpfr"].opt_prefix}
      --with-mpc=#{Formula["libmpc"].opt_prefix}
      --with-isl=#{Formula["isl"].opt_prefix}
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

  def caveats; <<-EOS.undent
    All in one minge-w64 formula is merged in Homebrew-core.
    That formula uses bottle mechanism.

    Please consider to migrate and use `mingw-w64' formula.
    This formula will continue to maintained for compatibility,
    but users should move to use homebrew-core formula.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/i686-w64-mingw32-gcc --version")
  end
end
