class Bitrise < Formula
  desc "Command-line automation tool"
  homepage "https://github.com/bitrise-io/bitrise"
  url "https://github.com/bitrise-io/bitrise/archive/1.44.1.tar.gz"
  sha256 "979bbbbd20b90695acb6bb82a94400b2e485c4406a5e0a7be43419bf223dee91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "fb6c9356eb5e2943c6b69510abf39a6f76a8b0df4a129683913960e1624c5284"
    sha256 cellar: :any_skip_relocation, catalina: "690a5b3322c47bed6730e1853d19f7a258e73ed8cfa192461be43bc3c5f68489"
    sha256 cellar: :any_skip_relocation, mojave: "ebe928f97d9533607d1a8d70b9dc9e35a0c77af1200962cbafcbfca59e9cfee9"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    # Install bitrise
    bitrise_go_path = buildpath/"src/github.com/bitrise-io/bitrise"
    bitrise_go_path.install Dir["*"]

    cd bitrise_go_path do
      prefix.install_metafiles

      system "go", "build", "-o", bin/"bitrise"
    end
  end

  test do
    (testpath/"bitrise.yml").write <<~EOS
      format_version: 1.3.1
      default_step_lib_source: https://github.com/bitrise-io/bitrise-steplib.git
      workflows:
        test_wf:
          steps:
          - script:
              inputs:
              - content: printf 'Test - OK' > brew.test.file
    EOS

    system "#{bin}/bitrise", "setup"
    system "#{bin}/bitrise", "run", "test_wf"
    assert_equal "Test - OK", (testpath/"brew.test.file").read.chomp
  end
end
