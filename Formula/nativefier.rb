require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/jiahaog/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-42.2.0.tgz"
  sha256 "64f28633b83d5e82e3aedbdf874b687f81e48ec2e0c4593ff7c24545738fa79b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "c06dbbba78ffa01f9fd378a8ad57279df0e8ae888031600672f9eb6bf24bdb2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8594f45fe1dfa480dfa57cda859d2e473229a94a05a7c39157ce1d804daf6d9"
    sha256 cellar: :any_skip_relocation, catalina: "25f5d5cd9320e000ff0511d5d1d657e48336bd3c43a86418f5f87bc0fd67fcbd"
    sha256 cellar: :any_skip_relocation, mojave: "2d9c67186099f3782fe0223427de7fa540b8c470435df7aaede594851400e152"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
