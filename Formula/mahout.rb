class Mahout < Formula
  desc "Library to help build scalable machine learning libraries"
  homepage "https://mahout.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=mahout/0.14.0/mahout-0.14.0-source-release.zip"
  mirror "https://archive.apache.org/dist/mahout/0.14.0/mahout-0.14.0-source-release.zip"
  sha256 "f95b257e3652ae9c6e6f649d154e7073cb554aa85bc996c9b483d796e2edab7d"
  license "Apache-2.0"
  head "https://github.com/apache/mahout.git"

  depends_on "maven" => :build
  depends_on "hadoop"
  depends_on :java => "1.8"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home("1.8")

    chmod 755, "./bin"
    system "mvn", "-DskipTests", "-DadditionalJOption=-Xdoclint:none", "clean", "install"

    libexec.install "bin"

    libexec.install Dir["buildtools/target/*.jar"]
    libexec.install Dir["core/target/*.jar"]
    libexec.install Dir["examples/target/*.jar"]
    libexec.install Dir["math/target/*.jar"]

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"test.csv").write <<~EOS
      "x","y"
      0.1234567,0.101201201
    EOS

    assert_match "0.101201201", pipe_output("#{bin}/mahout cat #{testpath}/test.csv")
  end
end
