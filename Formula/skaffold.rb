class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v1.18.0",
      revision: "efd0c52a28caa21bdc3e3f9ce3bbc18c42c94418"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "72d6ccc6b8d7877bf9046386706ddbdd4883a415a625a909be05857b23c994a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f1d4988b8f22f48f520a7bcb7c8276af693b3e4727e567a848857437f4dae64"
    sha256 cellar: :any_skip_relocation, catalina: "01c330ef0021dfb69be4b28800b78c6cb5032c00a40250e6ff2d07dfcba3e55c"
    sha256 cellar: :any_skip_relocation, mojave: "b0cda5ae4c94e4f8e237e2198ecf963025cac09c96314dd833d2b1d90a9c33d8"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "bash")
    (bash_completion/"skaffold").write output
    output = Utils.safe_popen_read("#{bin}/skaffold", "completion", "zsh")
    (zsh_completion/"_skaffold").write output
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"dockerfiles":["Dockerfile"]}', output
  end
end
