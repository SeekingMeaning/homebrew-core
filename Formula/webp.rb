class Webp < Formula
  desc "Image format providing lossless and lossy compression for web images"
  homepage "https://developers.google.com/speed/webp/"
  url "https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.1.0.tar.gz"
  sha256 "98a052268cc4d5ece27f76572a7f50293f439c17a98e67c4ea0c7ed6f50ef043"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, big_sur: "5723d4b2701f6c4348419164c38b11cd9c274dca35925fc8c3fbf0c8c14cfc4d"
    sha256 cellar: :any, arm64_big_sur: "823234931878dfebe1a66aa438011cfa24479bc86f6db537dccaf7c30dc8a384"
    sha256 cellar: :any, catalina: "27c76a7054277ff5a2e844c5996fc731d8644acbaaa505d35dba42c4a48a0c51"
    sha256 cellar: :any, mojave: "819c76cbf75c1d1d51db88602b69a9d9cd24975cc65834a9eb5a804c4b96ee35"
    sha256 cellar: :any, high_sierra: "069cac577750d53095cc43a05a3eab54310c35ea819ea05fa6bf425bcb0313d2"
  end

  head do
    url "https://chromium.googlesource.com/webm/libwebp.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-gif",
                          "--disable-gl",
                          "--enable-libwebpdecoder",
                          "--enable-libwebpdemux",
                          "--enable-libwebpmux"
    system "make", "install"
  end

  test do
    system bin/"cwebp", test_fixtures("test.png"), "-o", "webp_test.png"
    system bin/"dwebp", "webp_test.png", "-o", "webp_test.webp"
    assert_predicate testpath/"webp_test.webp", :exist?
  end
end
