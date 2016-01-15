require "formula"

class WinpthreadMingw32 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.4.tar.bz2"
  sha256 "89356a0aa8cf9f8b9dc8d92bc8dd01a131d4750c3acb30c6350a406316c42199"

  depends_on "gcc49" => :build
  depends_on "cosmo0920/mingw_w64/gcc-cross-mingw32"

  def install
    target_arch="i686-w64-mingw32"
    install_prefix="#{HOMEBREW_PREFIX}/mingw"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"

    args = %W[
      CC=i686-w64-mingw32-gcc
      CXX=i686-w64-mingw32-g++
      CPP=i686-w64-mingw32-cpp
      --host=#{target_arch}
      --prefix=#{install_prefix}/#{target_arch}
    ]

    chdir "mingw-w64-libraries/winpthreads" do
      system "./configure", *args
      system "make"
      system "make install"
    end
    # restore PATH
    ENV["PATH"] = path
  end

  def caveats; <<-EOS.undent
    If you uninstall or upgrade this formula, please remove #{prefix}/mingw before you do it.
    This is an issue that is unfortunately for now.
    In more detail, see: https://github.com/cosmo0920/homebrew-mingw_w64/issues/1
    EOS
  end
end
