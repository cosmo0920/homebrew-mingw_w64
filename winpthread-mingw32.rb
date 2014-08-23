require "formula"

class WinpthreadMingw32 < Formula
  homepage "http://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v3.1.0.tar.bz2"
  sha256 "ece7a7e7e1ab5e25d5ce469f8e4de7223696146fffa71c16e2a9b017d0e017d2"

  depends_on "gcc48" => :build
  depends_on "cosmo0920/mingw_w64/gcc-cross-mingw32"

  def install
    target_arch="i686-w64-mingw32"
    install_prefix="/usr/local/mingw/#{target_arch}"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"

    args = %W[
      --host=#{target_arch}
      --prefix=#{install_prefix}
    ]

    chdir "mingw-w64-libraries/winpthreads" do
      system "./configure", *args
      system "make"
      system "make install"
    end
    # restore PATH
    ENV["PATH"] = path
  end

end
