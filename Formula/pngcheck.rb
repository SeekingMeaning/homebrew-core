class Pngcheck < Formula
  desc "Print info and check PNG, JNG, and MNG files"
  homepage "http://www.libpng.org/pub/png/apps/pngcheck.html"
  url "http://www.libpng.org/pub/png/src/pngcheck-3.0.1.tar.gz"
  sha256 "66bf4cbaa29908984c0d7ba539358ed63c7c2f02a0b2407ac691465b143efbbb"
  license all_of: ["MIT", "GPL-2.0-or-later"]

  livecheck do
    url :homepage
    regex(/href=.*?pngcheck[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "e4d716fb0d3ff48095b36044e50b79fa80b8cfd962e9a58f0b227ade97bdbbc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bf4febdb6ed3286ae86ceadee979aac9e829e477abd5fb83c595d0edf605194b"
    sha256 cellar: :any_skip_relocation, catalina: "02af550fd568214ed59e4fc9d85359b48f4a9520d653fdfa53157f201a803208"
    sha256 cellar: :any_skip_relocation, mojave: "312428dc1c9917eb598d32e0889047adf9789e6b5aca9462f09817c93cfb2193"
  end

  def install
    system "make", "-f", "Makefile.unx", "ZINC=", "ZLIB=-lz"
    bin.install %w[pngcheck pngsplit png-fix-IDAT-windowsize]
  end

  test do
    system bin/"pngcheck", test_fixtures("test.png")
  end
end
