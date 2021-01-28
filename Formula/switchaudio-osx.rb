class SwitchaudioOsx < Formula
  desc "Change macOS audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://github.com/deweller/switchaudio-osx/archive/1.0.0.tar.gz"
  sha256 "c00389837ffd02b1bb672624fec7b75434e2d72d55574afd7183758b419ed6a3"
  license "MIT"
  head "https://github.com/deweller/switchaudio-osx.git"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, big_sur: "d577b2297c1865399ecbe4c7f2ac491063d75c786387502246b30d32e2606ee7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9971abdf1ae93055e74f4e1b48ad4ed0cf835069ed0750594156279d18b702e"
    sha256 cellar: :any_skip_relocation, catalina: "4a1ad0824d878dcabb3d7ffe4ad911f850383dbf2db28100e58f28cbc96657b7"
    sha256 cellar: :any_skip_relocation, mojave: "85d0fe91c72d1a61e331e475af4e6ded9d0ca3581612c1934835bc44653fe407"
    sha256 cellar: :any_skip_relocation, high_sierra: "26af506ea42b83ae8ccde71ed8b7666ccf3e3a349b2dd8958af7025854ffefd3"
    sha256 cellar: :any_skip_relocation, sierra: "89ed040cc50c7b7ad88a903da5351cfa0027a4daf22cf73f2713e0887847c5d1"
    sha256 cellar: :any_skip_relocation, el_capitan: "515b762164648d739ae36f8c5013d250d84af1264bf3ee366ed35adae2f44208"
  end

  depends_on xcode: :build

  def install
    xcodebuild "-project", "AudioSwitcher.xcodeproj",
               "-target", "SwitchAudioSource",
               "SYMROOT=build",
               "-verbose",
               # Force 64-bit for Mojave
               "-arch", "x86_64",
               # Default target is 10.5, which fails on Mojave
               "MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}"
    prefix.install Dir["build/Release/*"]
    bin.write_exec_script "#{prefix}/SwitchAudioSource"
    chmod 0755, "#{bin}/SwitchAudioSource"
  end

  test do
    system "#{bin}/SwitchAudioSource", "-c"
  end
end
