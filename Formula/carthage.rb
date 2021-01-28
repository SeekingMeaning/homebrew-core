class Carthage < Formula
  desc "Decentralized dependency manager for Cocoa"
  homepage "https://github.com/Carthage/Carthage"
  url "https://github.com/Carthage/Carthage.git",
      tag:      "0.36.1",
      revision: "07371d08a98276cceafc40f50b07804611b96011",
      shallow:  false
  license "MIT"
  head "https://github.com/Carthage/Carthage.git", shallow: false

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "67de3116e7bbb3e138070146194be5988d0ba74037b551ecaa39bb36c94650f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ce689a0d6f78a4c6626de681d91cb38adc302c47381d4cc9e560b4ef7abe9a62"
    sha256 cellar: :any_skip_relocation, catalina: "ea7058f92d8ce4b4d42b466cf32b9b65a9296174ec9028190f82b6149b5b44da"
    sha256 cellar: :any_skip_relocation, mojave: "3887e31cb3f75087bd9a8a83b84f194add534ef039039ea14b4843adc50bf82d"
  end

  depends_on xcode: ["10.0", :build]

  def install
    system "make", "prefix_install", "PREFIX=#{prefix}"
    bash_completion.install "Source/Scripts/carthage-bash-completion" => "carthage"
    zsh_completion.install "Source/Scripts/carthage-zsh-completion" => "_carthage"
    fish_completion.install "Source/Scripts/carthage-fish-completion" => "carthage.fish"
  end

  test do
    (testpath/"Cartfile").write 'github "jspahrsummers/xcconfigs"'
    system bin/"carthage", "update"
  end
end
