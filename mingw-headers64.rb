require "formula"

class MingwHeaders64 < Formula
  homepage "https://mingw-w64.sourceforge.net/"
  url "http://downloads.sourceforge.net/project/mingw-w64/mingw-w64/mingw-w64-release/mingw-w64-v4.0.4.tar.bz2"
  sha256 "89356a0aa8cf9f8b9dc8d92bc8dd01a131d4750c3acb30c6350a406316c42199"

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

    # Suppress empty installation warning
    touch prefix/"no-warning"
  end

end
