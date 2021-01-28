class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/creytiv/rem"
  url "https://github.com/creytiv/rem/releases/download/v0.6.0/rem-0.6.0.tar.gz"
  sha256 "417620da3986461598aef327c782db87ec3dd02c534701e68f4c255e54e5272c"

  bottle do
    sha256 cellar: :any, big_sur: "73f0aada894d478840f2999cee4b106c72f05799a1d4e43a6923a0c11ac626dd"
    sha256 cellar: :any, arm64_big_sur: "6fb5875de23967552524a374db07d928596fcf813fd659395dab15ffc93f8381"
    sha256 cellar: :any, catalina: "95862b3451f24c02dd50da1b7c5dfe798370431994f0b26f4418f6e68bc461ec"
    sha256 cellar: :any, mojave: "0303178e3833e6799d2863835cdd3a6c9e639b2fdcf5b3925bae1fb2690419f1"
    sha256 cellar: :any, high_sierra: "7b2cfbb41f81dd14636626f5d6e325d79cd7a69af540ddf722a7943a934c92ea"
    sha256 cellar: :any, sierra: "37e4fc160a28de520ac9ee23dafff09e8d6f733d022110782fd8aa2bda7245a4"
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
