class Licensee < Formula
  desc "Tool to detect under what license a project is distributed"
  homepage "https://licensee.github.io/licensee/"
  url "https://github.com/licensee/licensee/archive/v9.14.0.tar.gz"
  sha256 "7ae5fd36b5e13ea935a7492812f1a3dec1e71adc756dd245e6933f20b2437d3b"
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
    url "https://rubygems.org/gems/faraday-1.0.1.gem"
    sha256 "381aee04fcc9effbe5fa7cc703d8f5f20293722f987ded4f958f77514cd29373"
  end

  resource "mini_portile2" do
    url "https://rubygems.org/gems/mini_portile2-2.4.0.gem"
    sha256 "7e178a397ad62bb8a96977986130dc81f1b13201c6dd95a48bd8cec1dda5f797"
  end

  resource "multipart-post" do
    url "https://rubygems.org/gems/multipart-post-2.1.1.gem"
    sha256 "d2dd7aa957650e0d99e0513cd388401b069f09528441b87d884609c8e94ffcfd"
  end

  resource "nokogiri" do
    url "https://rubygems.org/gems/nokogiri-1.10.10.gem"
    sha256 "22ea03a328972467d7da06f4a7d5ac4f1f6410185efb55a4dae9cd222d30ae76"
  end

  resource "octokit" do
    url "https://rubygems.org/gems/octokit-4.18.0.gem"
    sha256 "26c24f2509e82da495a72df1aa36589dddf3c01251339746dcbac82a6dca6e7f"
  end

  resource "public_suffix" do
    url "https://rubygems.org/gems/public_suffix-4.0.6.gem"
    sha256 "a99967c7b2d1d2eb00e1142e60de06a1a6471e82af574b330e9af375e87c0cf7"
  end

  resource "reverse_markdown" do
    url "https://rubygems.org/gems/reverse_markdown-1.4.0.gem"
    sha256 "a3305da1509ac8388fa84a28745621113e121383402a2e8e9350ba649034e870"
  end

  resource "rugged" do
    url "https://rubygems.org/gems/rugged-1.0.1.gem"
    sha256 "76d55f519d3c982ce4bb4cda86b5c2761c66edd40c7391f55b73d9dd79e4cb14"
  end

  resource "sawyer" do
    url "https://rubygems.org/gems/sawyer-0.8.2.gem"
    sha256 "9f0d3988956cb22667f393a764f17b3b3649eb187b5e25f34005ea3b34642d7b"
  end

  resource "thor" do
    url "https://rubygems.org/gems/thor-1.0.1.gem"
    sha256 "7572061e3cbe6feee57828670e6a25a66dd397f05c1f8515d49f770a7d9d70f5"
  end

  # Allow use of Rugged v1.X
  # https://github.com/licensee/licensee/pull/447
  patch do
    url "https://github.com/licensee/licensee/commit/4653c15952daed8f30e3cd5d2eed717da17fd3a5.patch?full_index=1"
    sha256 "b02633d0be95879a208e8d0629aaef825383c038e2de9c71acad0b6fbfe47c6f"
  end

  def install
    ENV["GEM_HOME"] = libexec
    args = [
      "--ignore-dependencies",
      "--no-document",
      "--install-dir",
      libexec,
    ]
    (resources - [resource("rugged")]).each do |r|
      system "gem", "install", r.cached_download, *args
    end
    system "gem", "install", resource("rugged").cached_download, *args, "--", "--use-system-libraries"
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
