class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.4.0/libslirp-v4.4.0.tar.gz"
  sha256 "43513390c57bee8c23b31545bfcb765200fccf859062b1c8101e72befdabce2e"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3cd403d0ace2d57d506d64ce0bfcc27d3f7adb3e5113481a585a2f8ab0e53f9c"
    sha256 cellar: :any, big_sur:       "c246bdd605b4dd938e1973e3cc6e9855bfac88d2387aa40d41a85180554dc4ab"
    sha256 cellar: :any, catalina:      "1e17da7e87c39a76d7597c6030d2ae12d3b2a79742b4533e0113e7442e610833"
    sha256 cellar: :any, mojave:        "a2f636ece566472a1eb9db4761399a0a68bf1c2ca8b901a34d4205858704be90"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  # Fix QEMU networking
  # https://gitlab.freedesktop.org/slirp/libslirp/-/issues/35
  patch do
    url "https://gitlab.freedesktop.org/slirp/libslirp/-/commit/7271345efe182199acaeae602cb78a94a7c6dc9d.patch"
    sha256 "9b6fa60ad5ea251dda70c898078cbbc25b1dad035d1530d0cb5ae7db16333f92"
  end

  def install
    system "meson", "build", "-Ddefault_library=both", *std_meson_args
    system "ninja", "-C", "build", "install", "all"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <stddef.h>
      #include <slirp/libslirp.h>
      int main() {
        SlirpConfig cfg;
        memset(&cfg, 0, sizeof(cfg));
        cfg.version = 1;
        cfg.in_enabled = true;
        cfg.vhostname = "testServer";
        Slirp* ctx = slirp_new(&cfg, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lslirp", "-o", "test"
    system "./test"
  end
end
