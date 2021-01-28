class Gostatic < Formula
  desc "Fast static site generator"
  homepage "https://github.com/piranha/gostatic"
  url "https://github.com/piranha/gostatic/archive/2.25.tar.gz"
  sha256 "141ce5fa62841263557569d527989a0df2bdd83c6bc0b5e3c499a752a5e3c962"
  license "ISC"
  head "https://github.com/piranha/gostatic.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "f4a592b33ebf22ecff98f7a4e79f7178c3eb9f46b7280c1e1e772ac7fa988153"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "86d594016ca72d62cd81ae96a3ef882b6838e61ce80a0d552df8c3b27c5aca67"
    sha256 cellar: :any_skip_relocation, catalina: "f39d3c27ec9f9dcabaf26c6bd3a43212aba280b17edfd6a7e70fc119c883ad6f"
    sha256 cellar: :any_skip_relocation, mojave: "66e2cd38181bb076356fd50df4a045fd04691e9454cc7fdf60acd6e30c1408ea"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    (testpath/"config").write <<~EOS
      TEMPLATES = site.tmpl
      SOURCE = src
      OUTPUT = out
      TITLE = Hello from Homebrew

      index.md:
      \tconfig
      \text .html
      \tmarkdown
      \ttemplate site
    EOS

    (testpath/"site.tmpl").write <<~EOS
      {{ define "site" }}
      <html><head><title>{{ .Title }}</title></head><body>{{ .Content }}</body></html>
      {{ end }}
    EOS

    (testpath/"src/index.md").write "Hello world!"

    system bin/"gostatic", testpath/"config"
    assert_predicate testpath/"out/index.html", :exist?
  end
end
