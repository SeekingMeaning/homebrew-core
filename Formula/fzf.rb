class Fzf < Formula
  desc "Command-line fuzzy finder written in Go"
  homepage "https://github.com/junegunn/fzf"
  url "https://github.com/junegunn/fzf/archive/0.25.0.tar.gz"
  sha256 "ccbe13733d692dbc4f0e4c0d40c053cba8d22f309955803692569fb129e42eb0"
  license "MIT"
  head "https://github.com/junegunn/fzf.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, big_sur: "4785171206b293ad38415a377f49d6e7546c3918e6461fa7ef916881a4677d29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f55a17211677c905f56c9407892474f1da8c44bcd4192260abb05243cfd3a02"
    sha256 cellar: :any_skip_relocation, catalina: "888d72fea172e0901dd08364004510f8f842a61f0d5f9bcbc1e4bab92c41c768"
    sha256 cellar: :any_skip_relocation, mojave: "dc35db24918171592e325cd911bf7a17424f404904b355164ddc2295cd5bd645"
  end

  depends_on "go" => :build

  uses_from_macos "ncurses"

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w -X main.version=#{version} -X main.revision=brew"

    prefix.install "install", "uninstall"
    (prefix/"shell").install %w[bash zsh fish].map { |s| "shell/key-bindings.#{s}" }
    (prefix/"shell").install %w[bash zsh].map { |s| "shell/completion.#{s}" }
    (prefix/"plugin").install "plugin/fzf.vim"
    man1.install "man/man1/fzf.1", "man/man1/fzf-tmux.1"
    bin.install "bin/fzf-tmux"
  end

  def caveats
    <<~EOS
      To install useful keybindings and fuzzy completion:
        #{opt_prefix}/install

      To use fzf in Vim, add the following line to your .vimrc:
        set rtp+=#{opt_prefix}
    EOS
  end

  test do
    (testpath/"list").write %w[hello world].join($INPUT_RECORD_SEPARATOR)
    assert_equal "world", shell_output("cat #{testpath}/list | #{bin}/fzf -f wld").chomp
  end
end
