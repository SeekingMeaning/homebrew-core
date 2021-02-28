class PinboardNotesBackup < Formula
  desc "Efficiently back up the notes you've saved to Pinboard"
  homepage "https://github.com/bdesham/pinboard-notes-backup"
  url "https://github.com/bdesham/pinboard-notes-backup/archive/v1.0.5.1.tar.gz"
  sha256 "8fbe3bb48a8ef959e3f6e8758878182a569cbd6bb23c40c27f8a5b8053c81264"
  license "GPL-3.0-or-later"
  head "https://github.com/bdesham/pinboard-notes-backup.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:     "f5de063fa7d3ef372f34c0707fe22c4d1a9bef77142b221030ff75503d7a1194"
    sha256 cellar: :any_skip_relocation, catalina:    "1735309c67f5ff12f212c8f780fe0cfb3d0409c53ce9376ee265597ceb517693"
    sha256 cellar: :any_skip_relocation, mojave:      "244865afa3cd3d89f059dd4e6a162de07ce8d404c9ea2c05dc92ef17869c75e8"
    sha256 cellar: :any_skip_relocation, high_sierra: "cddc7122a3aa1aec17c18d2e50f471a154db42006684b7ba8d5fb4b2cfd5842f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.6" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "man/pnbackup.1"
  end

  # A real test would require hard-coding someone's Pinboard API key here
  test do
    assert_match "TOKEN", shell_output("#{bin}/pnbackup Notes.sqlite 2>&1", 1)
    output = shell_output("#{bin}/pnbackup -t token Notes.sqlite 2>&1", 1)
    assert_match "HTTP 500 response", output
  end
end
