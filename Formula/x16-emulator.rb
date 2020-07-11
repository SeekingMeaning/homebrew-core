class X16Emulator < Formula
  desc "Emulator for the Commander X16 8-bit computer"
  homepage "https://github.com/commanderx16/x16-emulator"
  url "https://github.com/commanderx16/x16-emulator/archive/r37.tar.gz"
  sha256 "0c9dbf76ceb5668c32d3b9f04538cdfe891826eaac6bf57c68b13a0152ce15d2"
  license "BSD-2-Clause"

  depends_on "cc65" => :build
  depends_on "sdl2"

  resource "rom" do
    url "https://github.com/commanderx16/x16-rom/archive/r37.tar.gz"
    sha256 "6d33326ac95c12f09efa328bbee4e8a4c285a42599199d8d5a93d28b5801deef"
  end

  def install
    resource("rom").stage do
      system "make", "BUILD_DIR=build"
      libexec.install "build/rom.bin"
    end
    system "make"
    libexec.install "x16emu"
    (bin/"x16emu").write <<~EOS
      #!/bin/bash
      cd #{libexec}
      exec ./x16emu "$@"
    EOS
  end

  test do
    output = shell_output("#{bin}/x16emu --help", 1)
    assert_match "Commander X16 Emulator", output
    assert_match "Usage: x16emu [option] ...", output
    assert_match "-rom <rom.bin>", output

    read, write = IO.pipe
    fork do
      exec bin/"x16emu", "-echo", :out => write
    end
    Timeout.timeout(10) do
      loop do
        break if read.gets.include? "COMMANDER X16 BASIC"
      end
      loop do
        break if read.gets.include? "512K HIGH RAM"
      end
      loop do
        break if read.gets.match? /[0-9]+ BASIC BYTES FREE/
      end
      loop do
        break if read.gets.include? "READY."
      end
    end
  end
end
