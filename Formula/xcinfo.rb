class Xcinfo < Formula
  desc "Tool to get information about and install available Xcode versions"
  homepage "https://github.com/xcodereleases/xcinfo"
  url "https://github.com/xcodereleases/xcinfo/archive/0.5.1.tar.gz"
  sha256 "ce943c6a9570b015fc8c02d3d3863e3fcd250d398c7518e089216b8409fd8f06"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "07c7b50b903770d63078ba45e61d167f9135299c731208ff02c8d8521525df5d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e7527a77fab417cb1b131c4dc2935d379567039d4a2745461491851ebf9f77b"
    sha256 cellar: :any_skip_relocation, catalina: "98e64cd5d992b20d9b8c52beb9599f7c6469ca1bb95746a97ac536ed9be85b79"
  end

  depends_on xcode: ["12.0", :build]
  depends_on macos: :catalina

  def install
    system "swift", "build",
           "--configuration", "release",
           "--disable-sandbox"
    bin.install ".build/release/xcinfo"
  end

  test do
    assert_match /12.3 RC 1 \(12C33\)/, shell_output("#{bin}/xcinfo list --all --no-ansi")
  end
end
