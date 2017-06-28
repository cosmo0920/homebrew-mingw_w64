class X8664W64Mingw32Gcc < Formula
  desc "Minimalist GNU for Windows with GCC."
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gcc/gcc-7.1.0/gcc-7.1.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-7.1.0/gcc-7.1.0.tar.bz2"
  sha256 "8a8136c235f64c6fef69cac0d73a46a1a09bb250776a050aec8f9fc880bebc17"

  depends_on "gcc" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "libmpc"
  depends_on "isl"
  depends_on "cosmo0920/mingw_w64/x86-64-w64-mingw32-binutils" => :build

  conflicts_with "mingw-w64", :because => "homebrew-core has mingw-w64 formula"

  resource "mingw-headers" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.2.tar.bz2"
    sha256 "5f46e80ff1a9102a37a3453743dae9df98262cba7c45306549ef7432cfd92cfd"
  end

  resource "gcc-core" do
    url "https://ftpmirror.gnu.org/gcc/gcc-7.1.0/gcc-7.1.0.tar.bz2"
    mirror "https://ftp.gnu.org/gnu/gcc/gcc-7.1.0/gcc-7.1.0.tar.bz2"
    sha256 "8a8136c235f64c6fef69cac0d73a46a1a09bb250776a050aec8f9fc880bebc17"
  end

  resource "mingw-runtime" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.2.tar.bz2"
    sha256 "5f46e80ff1a9102a37a3453743dae9df98262cba7c45306549ef7432cfd92cfd"
  end

  resource "mingw-winpthread" do
    url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v5.0.2.tar.bz2"
sha256 "5f46e80ff1a9102a37a3453743dae9df98262cba7c45306549ef7432cfd92cfd"
  end

  # Patch for mingw-w64 5.0.2 with GCC 7
  # https://sourceforge.net/p/mingw-w64/mingw-w64/ci/431ac2a912708546cd7271332e9331399e66bc62/
  resource "divmoddi4.patch" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/549c05c1f4/mingw-w64/divmoddi4.patch"
    sha256 "a8323a12b25baec1335e617111effc9236b48ce1162a63c4898bf6be12680c42"
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
        --enable-languages=c,c++,objc,obj-c++
        --with-gnu-as
        --with-gnu-ld
        --with-ld=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-ld"}
        --with-as=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-as"}
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
      --enable-languages=c,c++,objc,obj-c++
      --with-gnu-as
      --with-gnu-ld
      --with-ld=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-ld"}
      --with-as=#{Formula["x86-64-w64-mingw32-binutils"].opt_bin/"x86_64-w64-mingw32-as"}
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
      # stage and apply patch
      buildpath.install resource("divmoddi4.patch")
      system "patch", "-p1", "-i", buildpath/"divmoddi4.patch"

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

  def caveats; <<-EOS.undent
    All in one minge-w64 formula is merged in Homebrew-core.
    That formula uses bottle mechanism.

    Please consider to migrate and use `mingw-w64' formula.
    This formula will continue to maintained for compatibility,
    but users should move to use homebrew-core formula.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/x86_64-w64-mingw32-gcc --version")
  end
end
