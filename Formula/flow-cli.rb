class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.13.2.tar.gz"
  sha256 "65d9e2451e667c8466a4267cfbe75ab7ebb77b20549e59dfc4eef82b89812ba6"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "476c2aac8309c58cc02a6ea37c02375ea4863965a2fe2365d29666016eb19322"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce2f62ac82c2f922687280886fe72d88e606420f4f9940a0e717f6d1d3f829bb"
    sha256 cellar: :any_skip_relocation, catalina: "dcee5726d8c9d2428547b72827c605208e881d4ba29eeed253174bad90ef1052"
    sha256 cellar: :any_skip_relocation, mojave: "a1406f92147a7fe333c7e278431ce738940fa8429533d726c6b3e0fa34b1b959"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
