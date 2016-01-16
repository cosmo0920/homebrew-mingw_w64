require "formula"

class RuntimeMingw64 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.4.tar.bz2"
  sha256 "89356a0aa8cf9f8b9dc8d92bc8dd01a131d4750c3acb30c6350a406316c42199"

  depends_on "gcc49" => :build
  depends_on "cosmo0920/mingw_w64/binutils-mingw32"
  depends_on "cosmo0920/mingw_w64/mingw-headers32"
  depends_on "cosmo0920/mingw_w64/gcc-mingw32"

  def install
    install_prefix="#{HOMEBREW_PREFIX}/mingw"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = "x86_64-w64-mingw32"

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      rm "mingw" if Dir.exist?("mingw")
      ln_s "#{target_arch}", "mingw"
    end

    args = %W[
      CC=x86_64-w64-mingw32-gcc
      CXX=x86_64-w64-mingw32-g++
      CPP=x86_64-w64-mingw32-cpp
      LD=x86_64-w64-mingw32-gcc
      --host=#{target_arch}
      --prefix=#{install_prefix}/#{target_arch}
      --disable-lib32 --enable-lib64
    ]

    chdir "mingw-w64-crt" do
      system "./configure", *args
      system "make"
      system "make install"
    end
    # restore PATH
    ENV["PATH"] = path

    # Suppress empty installation warning
    touch prefix/"no-warning"
  end

end
