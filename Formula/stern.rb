class Stern < Formula
  desc "Tail multiple Kubernetes pods & their containers"
  homepage "https://github.com/stern/stern"
  url "https://github.com/stern/stern/archive/v1.13.1.tar.gz"
  sha256 "36eff0cd19bb5d60d2f6dfcecfe8afd2e95f00fff2e0e99f38eb99df11de1e61"
  license "Apache-2.0"
  head "https://github.com/stern/stern.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur: "fcb10818d0cbb75c642f304c81d22176a010a42ee60a9c4a1853129380ae5805"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "830637de6aa8964ff8a72ad5d92ed7b1ef1892c32833898c92fb94a9b373848f"
    sha256 cellar: :any_skip_relocation, catalina: "f42887e06595cc6f75e4600860f7795c71b5582476307c5222d612aed2a8c018"
    sha256 cellar: :any_skip_relocation, mojave: "f2bcd849ee63b84a23c8d2ed75ad123d70af5d73a7456feba9c332399f42658f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/stern/stern/cmd.version=#{version}", *std_go_args

    # Install shell completion
    output = Utils.safe_popen_read("#{bin}/stern", "--completion=bash")
    (bash_completion/"stern").write output

    output = Utils.safe_popen_read("#{bin}/stern", "--completion=zsh")
    (zsh_completion/"_stern").write output
  end

  test do
    assert_match "version: #{version}", shell_output("#{bin}/stern --version")
  end
end
