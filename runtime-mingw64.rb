require "formula"

class RuntimeMingw64 < Formula
  homepage "http://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v3.1.0.tar.bz2"
  sha256 "ece7a7e7e1ab5e25d5ce469f8e4de7223696146fffa71c16e2a9b017d0e017d2"

  depends_on "gcc48" => :build
  depends_on "cosmo0920/mingw_w64/binutils-mingw64"
  depends_on "cosmo0920/mingw_w64/mingw-headers64"
  depends_on "cosmo0920/mingw_w64/gcc-mingw64"

  def install
    install_prefix="/usr/local/mingw/"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = "x86_64-w64-mingw32"

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      system "rm mingw" if Dir.exist?("mingw")
      system "ln -s #{target_arch} mingw"
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

    mkdir "mingw-w64-crt" do
      system "./configure", *args
      system "make"
      system "make install"
    end
    # restore PATH
    ENV["PATH"] = path
  end

end
