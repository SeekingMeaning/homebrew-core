class XrootdAT4 < Formula
  desc "High performance, scalable, fault-tolerant access to data"
  homepage "https://xrootd.slac.stanford.edu/"
  url "https://xrootd.slac.stanford.edu/download/v4.12.3/xrootd-4.12.3.tar.gz"
  sha256 "6f2ca1accc8d49d605706bb556777c753860bf46d845b1ee11393a5cb5987f15"
  license "LGPL-3.0"

  keg_only :versioned_formula

  deprecate!

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DENABLE_PYTHON=OFF"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/xrootd", "-H"
  end
end
