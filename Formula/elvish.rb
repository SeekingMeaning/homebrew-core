class Elvish < Formula
  desc "Friendly and expressive shell"
  homepage "https://github.com/elves/elvish"
  url "https://github.com/elves/elvish/archive/v0.14.1.tar.gz"
  sha256 "8a8113c0a1325785b212ed59410869bdea30ca2cb7400f95ebb3fbc8689eb6d8"
  license "BSD-2-Clause"
  head "https://github.com/elves/elvish.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "0ce973f88b08a79b04f23bc36399d124ebc37f7ed15851e39d842e214648132e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f683a6e6d7034a4645f73aaa2cca531371a55465cd7999b4bcf9a20db4e126e8"
    sha256 cellar: :any_skip_relocation, catalina: "ba7fb1490f6a8bb5136d465a0ab60129f94d00ea996fa246214816e84a7fcf50"
    sha256 cellar: :any_skip_relocation, mojave: "13eefbaac25770a6d26e27bc1e061e6916ec5a258e0bd74c6980cd22b12ff121"
    sha256 cellar: :any_skip_relocation, high_sierra: "f17ce74f44eb978941acaf715849399ddf3e154e4425ac17b020c6da59e63af6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
           "-X github.com/elves/elvish/pkg/buildinfo.Version=#{version}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/elvish -version").chomp
    assert_match "hello", shell_output("#{bin}/elvish -c 'echo hello'")
  end
end
