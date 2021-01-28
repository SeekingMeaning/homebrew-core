class LibxdgBasedir < Formula
  desc "C implementation of the XDG Base Directory specifications"
  homepage "https://github.com/devnev/libxdg-basedir"
  url "https://github.com/devnev/libxdg-basedir/archive/libxdg-basedir-1.2.0.tar.gz"
  sha256 "1c2b0032a539033313b5be2e48ddd0ae94c84faf21d93956d53562eef4614868"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur: "3f6d2cac0e17098e540c5da2be7a2893895c1c4b72506198e1bb2877feec8861"
    sha256 cellar: :any, arm64_big_sur: "c1dfda867b69189c34e5a48f3c089f23d623cce8436fa68299d90715bee42b7f"
    sha256 cellar: :any, catalina: "3d1776b30c96451960647fe4dbac15af5c6c2d85907731a54eeaf6456915a8a2"
    sha256 cellar: :any, mojave: "d737fa3c4f67f250dd7443702868bc4204cff2d05bc7bf0efe54e7efe64655fa"
    sha256 cellar: :any, high_sierra: "f5b940765c84d65ecd0baddcc03eab2bc612a090db48e6309b411f13e7a3c714"
    sha256 cellar: :any, sierra: "00953ec922b6ebac6e27b1f8e1139fcc1cc5b9f8312dc8d0ebe69778c884c1b7"
    sha256 cellar: :any, el_capitan: "30b3e34a46470f11d90ca01aebd2b2d1fbaa6cc8a05c1bcec7067d40fdec75d1"
    sha256 cellar: :any, yosemite: "7e165b0e949f559789981a5c0e0fd68bbf478943a0c9b03ad3778cecb0219691"
    sha256 cellar: :any, mavericks: "5c7bfadf4ca8b26c077eea7480df5a4ca3634b5823860a06ce2756050acbe84a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--disable-dependency-tracking",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <basedir.h>
      int main() {
        xdgHandle handle;
        if (!xdgInitHandle(&handle)) return 1;
        xdgWipeHandle(&handle);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lxdg-basedir", "-o", "test"
    system "./test"
  end
end
