class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  url "https://www.opendap.org/pub/source/libdap-3.20.7.tar.gz"
  sha256 "6856813d0b29e70a36e8a53e9cf20ad680d21d615952263e9c6586704539e78c"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur: "660a8cd6c01ce10d30ec4dda70912cefe949b3aa5b56756c14cba5120b0f579e"
    sha256 arm64_big_sur: "232beef8fecad3beed966204d1bf42622e637492fc161801ff1c352ae429ce4b"
    sha256 catalina: "7664a9d567e5c0304ce2430cb93d02fd3431ef480105170c130327cb09da014e"
    sha256 mojave: "ab8664fda0c8a71409c54315011992d397315c15a5842f83771f7c30d2eafa8c"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    system "autoreconf", "-fvi" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
