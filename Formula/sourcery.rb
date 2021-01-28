class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.0.2.tar.gz"
  sha256 "8125f7e7be289053d2a66a853dac0cf8d18e8b93ccd6bdf1ae70cd688232135d"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "f717a8df9128e3714c72edea739f7ea8fa1aebce8a5204d7ac7ac2f03c7c6b16"
    sha256 cellar: :any_skip_relocation, catalina: "7374695fa0685ccb4f432b260c8a2bd33e7d9f8ade55ae7ade0dece6771006bb"
  end

  depends_on xcode: "12.0"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "-Xswiftc",
                             "-target", "-Xswiftc", "x86_64-apple-macosx10.11"
    bin.install ".build/release/sourcery"
    lib.install Dir[".build/release/*.dylib"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
