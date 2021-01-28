class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://gentoo.com/di/di-4.48.tar.gz"
  sha256 "19d549feb59ccde7ff1cd2c48fea7b9ba99fa2285da81424603e23d8b5db3b33"
  license "Zlib"

  livecheck do
    url :homepage
    regex(%r{<p>Current Version: v?(\d+(?:\.\d+)+)</p>}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "0ffebbfd7342f23bb63e5263a942a6f414db1fba83b7afceba2f2f9ada54384b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1eb349a529af3d604dd740f0e95a6d5fe6c200ab32074f2d5241cb2c0952f72a"
    sha256 cellar: :any_skip_relocation, catalina: "c49db9fca46dd848d4cf5badc22524ab66f8169c6368a7839023b3593969f451"
    sha256 cellar: :any_skip_relocation, mojave: "e3ba587be02153b3fc475ffe3dfc21714ce0e82e9a4d03d32e9ecaff4400e287"
    sha256 cellar: :any_skip_relocation, high_sierra: "14522350f027f600e28be34b412ba66ab95c1fcbbce81dd064826493165aa142"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
