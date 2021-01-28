class DockerSlim < Formula
  desc "Minify and secure Docker images"
  homepage "https://dockersl.im"
  url "https://github.com/docker-slim/docker-slim/archive/1.33.0.tar.gz"
  sha256 "62a3fde9a60db751aeac0e0343375136524b9e3264479400e3ba5cbceef107d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "7c17616fc4324b0d42a6dd219ce1f538b5cd6b7615ec1367b9a0ec7807cf9f7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb028bd6770d46b4cabf79d98bd7726639cd6e81289109d50d8807634eee1f80"
    sha256 cellar: :any_skip_relocation, catalina: "166d855c4d206122ce2c47d51aa817eefd8b16551cd0651093f86668e388b4a1"
    sha256 cellar: :any_skip_relocation, mojave: "a39e6ca02acc7dab652ee27e54c4440e297ef75749c2d256ad977417448bd28a"
  end

  depends_on "go" => :build

  skip_clean "bin/docker-slim-sensor"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X github.com/docker-slim/docker-slim/pkg/version.appVersionTag=#{version}"
    system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o",
           bin/"docker-slim", "./cmd/docker-slim"

    # docker-slim-sensor is a Linux binary that is used within Docker
    # containers rather than directly on the macOS host.
    ENV["GOOS"] = "linux"
    system "go", "build", "-trimpath", "-ldflags=#{ldflags}", "-o",
           bin/"docker-slim-sensor", "./cmd/docker-slim-sensor"
    (bin/"docker-slim-sensor").chmod 0555
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-slim --version")
    system "test", "-x", bin/"docker-slim-sensor"
  end
end
