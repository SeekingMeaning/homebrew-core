class Alluxio < Formula
  desc "Open Source Memory Speed Virtual Distributed Storage"
  homepage "https://www.alluxio.io/"
  url "https://downloads.alluxio.io/downloads/files/2.3.0/alluxio-2.3.0-bin.tar.gz"
  sha256 "7147c0957e6ea2c89d4b85867524ecaa5f038291f0f6be4a22320f4adae2253d"

  bottle :unneeded

  patch :DATA

  def default_alluxio_conf
    <<~EOS
      alluxio.master.hostname=localhost
    EOS
  end

  def install
    doc.install Dir["docs/*"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]

    rm_rf Dir["#{etc}/alluxio/*"]

    (etc/"alluxio").install libexec/"conf/alluxio-env.sh.template" => "alluxio-env.sh"
    ln_sf "#{etc}/alluxio/alluxio-env.sh", "#{libexec}/conf/alluxio-env.sh"

    defaults = etc/"alluxio/alluxio-site.properties"
    defaults.write(default_alluxio_conf) unless defaults.exist?
    ln_sf "#{etc}/alluxio/alluxio-site.properties", "#{libexec}/conf/alluxio-site.properties"
  end

  def caveats
    <<~EOS
      To configure alluxio, edit
        #{etc}/alluxio/alluxio-env.sh
        #{etc}/alluxio/alluxio-site.properties
    EOS
  end

  test do
    system bin/"alluxio", "version"
  end
end

__END__
diff --git a/alluxio/v2.3.0/libexec/alluxio-config.sh b/alluxio/v2.3.0/libexec/alluxio-config.sh
index 3569b96..612df11 100644
--- a/alluxio/v2.3.0/libexec/alluxio-config.sh
+++ b/alluxio/v2.3.0/libexec/alluxio-config.sh
@@ -51,12 +51,6 @@ if [[ -z "${JAVA}" ]]; then
   fi
 fi
 
-# Check Java version == 1.8
-JAVA_VERSION=$(${JAVA} -version 2>&1 | awk -F '"' '/version/ {print $2}')
-if [[ $(echo "${JAVA_VERSION}" | awk -F. '{printf("%03d%03d",$1,$2);}') != 001008 ]]; then
-  echo "Error: Alluxio requires Java 8, currently Java $JAVA_VERSION found."
-  exit 1
-fi
 
 if [[ -n "${ALLUXIO_HOME}" ]]; then
   ALLUXIO_JAVA_OPTS+=" -Dalluxio.home=${ALLUXIO_HOME}"
