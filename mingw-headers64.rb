require "formula"

class MingwHeaders64 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.2.tar.bz2"
  sha256 "3e9050a8c6689ef8a0cfafa40a7653e8c347cf93c105d547239c573afe7b8952"

  depends_on "gcc49" => :build

  def install
    install_prefix="#{HOMEBREW_PREFIX}/mingw/x86_64-w64-mingw32"
    args = %W[
      --host=x86_64-w64-mingw32
      --prefix=#{install_prefix}
      --enable-sdk=all
      --enable-secure-api
    ]

    mkdir "build-headers" do
      system "../mingw-w64-headers/configure", *args
      system "make"
      system "make install"
    end
  end

end
