class Libextractor < Formula
  desc "Library to extract meta data from files"
  homepage "https://www.gnu.org/software/libextractor/"
  url "https://ftp.gnu.org/gnu/libextractor/libextractor-1.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/libextractor/libextractor-1.10.tar.gz"
  sha256 "9eed11b5ddc7c929ba112c50de8cfaa379f1d99a0c8e064101775837cf432357"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 big_sur: "57cc73af98204c3c4cd49c7121b34a2f4a312112700226df6d694d0a09e3bf6f"
    sha256 arm64_big_sur: "d57a5379b72fae761386f624d0c21dd164fff53032642472b96c66bf458dbdc7"
    sha256 catalina: "1f9781fe4c690eca0d719016cd4f23bd94890ae69cc30c4c1caa47d919286483"
    sha256 mojave: "0929de2de549d871c775fb2b3aaf22dc52377b504b8ed3d01ca9350a52704e39"
    sha256 high_sierra: "5a30c428cb327ef0bfd2458feeeb638200df28acf63b688d598a79591cb1c812"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"

  conflicts_with "csound", because: "both install `extract` binaries"
  conflicts_with "pkcrack", because: "both install `extract` binaries"

  def install
    ENV.deparallelize

    system "./configure", "--disable-silent-rules",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    assert_match /Keywords for file/, shell_output("#{bin}/extract #{fixture}")
  end
end
