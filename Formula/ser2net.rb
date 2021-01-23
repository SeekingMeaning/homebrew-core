class Ser2net < Formula
  desc "Allow network connections to serial ports"
  homepage "https://ser2net.sourceforge.io"
  url "https://downloads.sourceforge.net/project/ser2net/ser2net/ser2net-4.3.1.tar.gz"
  sha256 "dbf84f29440e2f00b77d3b722b04b48119ef3d3571651e264ad59c10040cbe82"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/ser2net[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "daff205c7e62f7a0ad6ce064b5005f80f4e8362b17a2cb3ad87676174d683ba7" => :big_sur
    sha256 "61d93dbd74a72555d27f9f24e567f5c8a586e63ff348f429573d9f1246f02c63" => :arm64_big_sur
    sha256 "3477841d573b2612fff98a0dd1fa8ac46e3d43fdc110ddfd3767f6b433b344a4" => :catalina
    sha256 "822c56bfd75eccbdcc8a447236c996ca146e5efe324eea471dbbc212611dc0be" => :mojave
    sha256 "b11cef34c33d9f40ac677c034ff1557444d69735f3d5c88e8eaaffd135237d7d" => :high_sierra
  end

  depends_on "libyaml"

  resource "gensio" do
    url "https://downloads.sourceforge.net/project/ser2net/ser2net/gensio-2.2.3.tar.gz"
    sha256 "ffc849be3349ba15cd6f92d109a54c7608c15d33d210a262c02ddcf00ea76262"
  end

  def install
    resource("gensio").stage do
      system "./configure", "--with-python=no",
                            "--disable-dependency-tracking",
                            "--prefix=#{libexec}/gensio"
      system "make", "install"
    end

    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/gensio/lib/pkgconfig"
    ENV.append_path "CFLAGS", "-I#{libexec}/gensio/include"
    ENV.append_path "LDFLAGS", "-L#{libexec}/gensio/lib"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    system "make", "install"

    (etc/"ser2net").install "ser2net.yaml"
  end

  def caveats
    <<~EOS
      To configure ser2net, edit the example configuration in #{etc}/ser2net/ser2net.yaml
    EOS
  end

  plist_options manual: "ser2net -p 12345"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
              <string>#{opt_sbin}/ser2net</string>
              <string>-p</string>
              <string>12345</string>
          </array>
          <key>WorkingDirectory</key>
          <string>#{HOMEBREW_PREFIX}</string>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{sbin}/ser2net -v")
  end
end
