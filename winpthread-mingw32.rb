require "formula"

class WinpthreadMingw32 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.2.tar.bz2"
  sha256 "3e9050a8c6689ef8a0cfafa40a7653e8c347cf93c105d547239c573afe7b8952"

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
