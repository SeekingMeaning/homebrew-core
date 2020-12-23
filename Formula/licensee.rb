class Licensee < Formula
  desc "Tool to detect under what license a project is distributed"
  homepage "https://licensee.github.io/licensee/"
  url "https://github.com/licensee/licensee/archive/v9.14.1.tar.gz"
  sha256 "9f90024b4b8de833349c1365ada86657bc6dc25c4cce15c6e5230883a6d39294"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "libgit2"
  depends_on "ruby"

  resource "addressable" do
    url "https://rubygems.org/gems/addressable-2.7.0.gem"
    sha256 "5e9b62fe1239091ea9b2893cd00ffe1bcbdd9371f4e1d35fac595c98c5856cbb"
  end

  resource "dotenv" do
    url "https://rubygems.org/gems/dotenv-2.7.6.gem"
    sha256 "2451ed5e8e43776d7a787e51d6f8903b98e446146c7ad143d5678cc2c409d547"
  end

  resource "faraday" do
    url "https://rubygems.org/gems/faraday-1.3.0.gem"
    sha256 "7f06817ba823ddeabf4dd85ca5e0f63e234527f564a03f09f6c7127951d3bac2"
  end

  resource "faraday-net_http" do
    url "https://rubygems.org/gems/faraday-net_http-1.0.0.gem"
    sha256 "cd648c0343e41cb93fcd1db63dbe25e24ba623b79fbd42b9e275755b586865ce"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.5.0.gem"
    sha256 "a7a7a09d646619d8efb0898169806266bf2982c70cc131fd285aa25e55bdabc1"
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.1.1.gem"
    sha256 "d2dd7aa957650e0d99e0513cd388401b069f09528441b87d884609c8e94ffcfd"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.11.1.gem"
    sha256 "42c2a54dd3ef03ef2543177bee3b5308313214e99f0d1aa85f984324329e5caa"
  end

  resource "octokit" do
    url "https://rubygems.org/gems/octokit-4.20.0.gem"
    sha256 "d853f83be36bba94d21c7f31243c8e89fa7ed64c6e5ca83da540eed2e80985ba"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.6.gem"
    sha256 "a99967c7b2d1d2eb00e1142e60de06a1a6471e82af574b330e9af375e87c0cf7"
  end

  resource "racc" do
    url "https://rubygems.org/gems/racc-1.5.2-java.gem"
    sha256 "110bbf9cd6f26eea22852fe112e251394dffac17268ac0c995df8798e6741b87"
  end

  resource "reverse_markdown" do
    url "https://rubygems.org/gems/reverse_markdown-1.4.0.gem"
    sha256 "a3305da1509ac8388fa84a28745621113e121383402a2e8e9350ba649034e870"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/gems/ruby2_keywords-0.0.2.gem"
    sha256 "145c91edd2ef4c509403328ed05ae4387a8841b7a3ae93679e71c0fd3860ec9e"
  end

  resource "rugged" do
    url "https://rubygems.org/gems/rugged-1.1.0.gem"
    sha256 "1e735697b7c396071576fe6d0eae3164f435fec3c2e442c3e1b2337a47485811"
  end

  resource "sawyer" do
    url "https://rubygems.org/gems/sawyer-0.8.2.gem"
    sha256 "9f0d3988956cb22667f393a764f17b3b3649eb187b5e25f34005ea3b34642d7b"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.0.1.gem"
    sha256 "7572061e3cbe6feee57828670e6a25a66dd397f05c1f8515d49f770a7d9d70f5"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      args = ["--ignore-dependencies", "--no-document", "--install-dir=#{libexec}"]
      args += ["--", "--use-system-libraries"] if r.name == "rugged"
      system "gem", "install", r.cached_download, *args
    end

    system "gem", "build", "licensee.gemspec"
    system "gem", "install", "--ignore-dependencies", "licensee-#{version}.gem"

    (libexec/"gems/licensee-#{version}").install Dir["*"]
    bin.install libexec/"bin/licensee"
    bin.env_script_all_files libexec/"bin", GEM_HOME: ENV["GEM_HOME"]

    # Avoid references to Homebrew shims
    rm_f Dir[libexec/"extensions/**/mkmf.log"]
  end

  test do
    (testpath/"LICENSE").write <<~EOS
      Permission is hereby granted, free of charge, to any person obtaining a copy
      of this software and associated documentation files (the "Software"), to deal
      in the Software without restriction, including without limitation the rights
      to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
      copies of the Software, and to permit persons to whom the Software is
      furnished to do so, subject to the following conditions:

      The above copyright notice and this permission notice shall be included in all
      copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
      IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
      FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
      AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
      LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
      OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
      SOFTWARE.
    EOS
    expected_output = <<~EOS
      License:        MIT
      Matched files:  LICENSE
      LICENSE:
        Content hash:  d64f3bb4282a97b37454b5bb96a8a264a3363dc3
        Confidence:    100.00%
        Matcher:       Licensee::Matchers::Exact
        License:       MIT
    EOS
    assert_match expected_output, shell_output("#{bin}/licensee detect #{testpath}")
  end
end
