require "formula"

class WinpthreadMingw64 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.4.tar.bz2"
  sha256 "89356a0aa8cf9f8b9dc8d92bc8dd01a131d4750c3acb30c6350a406316c42199"

  depends_on "gcc49" => :build
  depends_on "cosmo0920/mingw_w64/gcc-cross-mingw64"

  def install
    target_arch="x86_64-w64-mingw32"
    install_prefix="#{HOMEBREW_PREFIX}/mingw"
    path = ENV["PATH"]
    ENV.prepend_path 'PATH', "#{install_prefix}/bin"

    args = %W[
      CC=x86_64-w64-mingw32-gcc
      CXX=x86_64-w64-mingw32-g++
      CPP=x86_64-w64-mingw32-cpp
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
