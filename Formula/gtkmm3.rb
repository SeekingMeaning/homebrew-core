class Gtkmm3 < Formula
  desc "C++ interfaces for GTK+ and GNOME"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.3.tar.xz"
  sha256 "60497c4f7f354c3bd2557485f0254f8b7b4cf4bebc9fee0be26a77744eacd435"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/gtkmm[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, big_sur: "a9edf47cb30a08e2d0f4186496a80179b669f9614dbf507c16d2622de81469d6"
    sha256 cellar: :any, arm64_big_sur: "1310adafe8f33f29ab44381f0d7ea64e425a905e6e0fc69659acf9ec9b4d687c"
    sha256 cellar: :any, catalina: "5ff071cb276599b4ac5882fdf06cdcdae29972506b2bf90bfc645e5d755c5dd3"
    sha256 cellar: :any, mojave: "93419c34bd858fb3d19c574365a69e41f5163fa6a342070ae65e7c96fc3007e7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "gtk+3"
  depends_on "pangomm@2.42"

  def install
    ENV.cxx11

    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <gtkmm.h>
      class MyLabel : public Gtk::Label {
        MyLabel(Glib::ustring text) : Gtk::Label(text) {}
      };
      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs gtkmm-3.0").strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
