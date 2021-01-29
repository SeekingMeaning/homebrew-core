class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://gnupg.org/related_software/libgcrypt/"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.7.tar.bz2"
  sha256 "03b70f028299561b7034b8966d7dd77ef16ed139c43440925fe8782561974748"
  license "GPL-2.0-only"
  revision 1
  version_scheme 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgcrypt/"
    regex(/libgcrypt[._-]v?(\d+\.\d+\.\d+)/i)
  end

  bottle do
    cellar :any
    sha256 "95b397a91da34341ceff718abde87771be2616d240d6937bda7cffb66222fa0f" => :big_sur
    sha256 "a2309b77960d96cb14e3fd33f29a61d53357de52bf3bb92205d3e2d1923f042e" => :arm64_big_sur
    sha256 "6b3385316b48bd4b86e91317f125a715d0ecaf3ff4c2c15bc7eab3de70f29bf9" => :catalina
    sha256 "b3fbe8acbb01d243a7c40a0bfc2834ff0ff91064bf86a4d0e94a721285eb25d9" => :mojave
  end

  depends_on "libgpg-error"

  # Upstream patch which corrects the pkg-config flags to include the header and library paths
  # Important on non /usr/local prefixes
  # https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=commit;h=761d12f140b77b907087590646651d9578b68a54
  patch do
    url "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=libgcrypt.git;a=patch;h=761d12f140b77b907087590646651d9578b68a54"
    sha256 "f4da2d8c93bc52a26efa429a81d32141246d163d752464cd17ac9cce27d1fc64"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--disable-jent-support" # Requires ENV.O0, which is unpleasant.

    # Parallel builds work, but only when run as separate steps
    system "make"
    on_macos do
      # Slightly hideous hack to help `make check` work in
      # normal place on >10.10 where SIP is enabled.
      # https://github.com/Homebrew/homebrew-core/pull/3004
      # https://bugs.gnupg.org/gnupg/issue2056
      MachO::Tools.change_install_name("#{buildpath}/tests/.libs/random",
                                       "#{lib}/libgcrypt.20.dylib",
                                       "#{buildpath}/src/.libs/libgcrypt.20.dylib")
      MachO.codesign!("#{buildpath}/tests/.libs/random") if Hardware::CPU.arm?
    end

    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libgcrypt-config", prefix, opt_prefix
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end
