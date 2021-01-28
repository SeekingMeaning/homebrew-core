class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/lgt3430stable.tar.gz"
  version "3.43.0"
  sha256 "7e38652183d022abe7f41014037c9d334a445f8294e72426068c1d62170a0ac5"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "7f92e746a72fb33582555a78a128db9d48dd74bfd1e28d119b9d3a834dddbd6c"
    sha256 cellar: :any_skip_relocation, catalina: "e1c9def39f7585aaa0047fc8a0550a02820b796ba6691a437487f589ca56573c"
    sha256 cellar: :any_skip_relocation, mojave: "da60c7e264ea48b3990ab4dcc0cbd3c9cc33e7c37b076671f8da7f071e96ee90"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end
