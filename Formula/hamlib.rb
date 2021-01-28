class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.0/hamlib-4.0.tar.gz"
  sha256 "1fa24d4a8397b29a29f39be49c9042884d524b7a584ea8852bd770bd658d66f2"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    rebuild 1
    sha256 cellar: :any, big_sur: "fe04cc5576e85b4b22a07e0b681bbae881c9bb639fc0be19500b1e94b7803d43"
    sha256 cellar: :any, arm64_big_sur: "8faea293fa6fd60893c05571b2d52b52339866d4c65fb103d097ccbe91897aa9"
    sha256 cellar: :any, catalina: "cf210e6b1a182e52f93c26e99b36e76db21b5b11ab45f30f553dbb58f51cd936"
    sha256 cellar: :any, mojave: "d45e4cdde74cac09f37a111e965cfb9cfa110ff68b15ea8575766bf161697704"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
