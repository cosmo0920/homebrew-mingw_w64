require "formula"

class RuntimeMingw32 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v3.1.0.tar.bz2"
  sha256 "ece7a7e7e1ab5e25d5ce469f8e4de7223696146fffa71c16e2a9b017d0e017d2"

  depends_on "gcc48" => :build
  depends_on "cosmo0920/mingw_w64/binutils-mingw32"
  depends_on "cosmo0920/mingw_w64/mingw-headers32"
  depends_on "cosmo0920/mingw_w64/gcc-mingw32"

  def install
    install_prefix="/usr/local/mingw/"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"
    target_arch = "i686-w64-mingw32"

    # create symlink to `/usr/local/mingw//mingw/include`
    chdir "#{install_prefix}" do
      rm "mingw" if Dir.exist?("mingw")
      ln "-s", "#{target_arch}", "mingw"
    end

    args = %W[
      CC=i686-w64-mingw32-gcc
      CXX=i686-w64-mingw32-g++
      CPP=i686-w64-mingw32-cpp
      LD=i686-w64-mingw32-gcc
      --host=#{target_arch}
      --prefix=#{install_prefix}/#{target_arch}
      --disable-lib64 --enable-lib32
    ]

    chdir "mingw-w64-crt" do
      system "./configure", *args
      system "make"
      system "make install"
    end
    # restore PATH
    ENV["PATH"] = path
  end

end
