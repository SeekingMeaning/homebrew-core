class LibomxilBellagio < Formula
  desc "Open-source implementation of the OpenMAX Integration Layer"
  homepage "https://omxil.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omxil/omxil/Bellagio%200.9.3/libomxil-bellagio-0.9.3.tar.gz"
  sha256 "593c0729c8ef8c1467b3bfefcf355ec19a46dd92e31bfc280e17d96b0934d74c"
  license "LGPL-2.1-or-later"

  depends_on "pkg-config" => [:build, :test]
  depends_on :linux

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dependency-tracking"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "-I#{include}", shell_output("pkg-config --cflags libomxil-bellagio")
    (testpath/"test.c").write <<~EOS
      #include <OMX_Core.h>
      int main(int argc, char* argv[]) {
        OMX_Init();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lomxil-bellagio"
  end
end
