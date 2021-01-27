class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/20200923.3.tar.gz"
  sha256 "ebe2ad1480d27383e4bf4211e2ca2ef312d5e6a09eba869fd2e8a5c5d553ded2"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 "e16d12f4d5eb788fc774d1cc6d328a659bfc56f0cef74244396f2453890bb9ed" => :big_sur
    sha256 "0b4448de8c7a176da27c895da37c7edbadabd304a2d5ddb76c7d134f7b130e4d" => :arm64_big_sur
    sha256 "648a6091da13e90637b3579249ae8821292ca96efb95cd1d4a5a649d553c6ef6" => :catalina
    sha256 "0879e0af3745923b219e99af5355100a4a8e4c944167414e038633a6779736d0" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :test

  # Generate pkg-config files
  # https://github.com/abseil/abseil-cpp/commit/eb317a701b83bf9a4f2a035d75747a3d76a48324
  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..",
                      *std_cmake_args,
                      "-DCMAKE_INSTALL_RPATH=#{lib}",
                      "-DCMAKE_CXX_STANDARD=17",
                      "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-labsl_strings",
                    "test.cc", "-o", "test"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/test")

    (testpath/"hello.cc").write <<~EOS
      #include <cstdlib>
      #include "absl/strings/str_format.h"

      int main() {
        absl::PrintF("Hello Abseil!\\n");
      }
    EOS
    pkg_config_flags = shell_output("pkg-config --cflags --libs --static absl_str_format").chomp.split
    system ENV.cxx, "-std=c++17", *pkg_config_flags, "hello.cc", "-o", "hello"
    assert_equal "Hello Abseil!\n", shell_output("./hello")
  end
end
__END__
diff --git a/CMake/AbseilHelpers.cmake b/CMake/AbseilHelpers.cmake
index 8b2925c52ba5f6d3c5b4209566cc3b6f85d3eef2..e63db3a87b94f8448ad71090231a4d845963b2eb 100644
--- a/CMake/AbseilHelpers.cmake
+++ b/CMake/AbseilHelpers.cmake
@@ -137,6 +137,45 @@ function(absl_cc_library)
     set(_build_type "static")
   endif()
 
+  # Generate a pkg-config file for every library:
+  if(${_build_type} STREQUAL "static" OR ${_build_type} STREQUAL "shared")
+    if(NOT ABSL_CC_LIB_TESTONLY)
+      if(absl_VERSION)
+        set(PC_VERSION "${absl_VERSION}")
+      else()
+        set(PC_VERSION "head")
+      endif()
+      foreach(dep ${ABSL_CC_LIB_DEPS})
+        if(${dep} MATCHES "^absl::(.*)")
+          set(PC_DEPS "${PC_DEPS} absl_${CMAKE_MATCH_1} = ${PC_VERSION}")
+        endif()
+      endforeach()
+      foreach(cflag ${ABSL_CC_LIB_COPTS})
+        if(${cflag} MATCHES "^(-Wno|/wd)")
+          # These flags are needed to suppress warnings that might fire in our headers.
+          set(PC_CFLAGS "${PC_CFLAGS} ${cflag}")
+        elseif(${cflag} MATCHES "^(-W|/w[1234eo])")
+          # Don't impose our warnings on others.
+        else()
+          set(PC_CFLAGS "${PC_CFLAGS} ${cflag}")
+        endif()
+      endforeach()
+      FILE(GENERATE OUTPUT "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/absl_${_NAME}.pc" CONTENT "\
+prefix=${CMAKE_INSTALL_PREFIX}\n\
+exec_prefix=\${prefix}\n\
+libdir=\${prefix}/lib\n\
+includedir=\${prefix}/include\n\
+\n\
+Name: absl_${_NAME}\n\
+Description: Abseil ${_NAME} library\n\
+URL: https://abseil.io/\n\
+Version: ${PC_VERSION}\n\
+Requires.private:${PC_DEPS}\n\
+Libs: -L\${libdir} $<JOIN:${ABSL_CC_LIB_LINKOPTS}, > $<$<NOT:$<BOOL:${ABSL_CC_LIB_IS_INTERFACE}>>:-labsl_${_NAME}>\n\
+Cflags: -I\${includedir}${PC_CFLAGS}\n")
+    endif()
+  endif()
+
   if(NOT ABSL_CC_LIB_IS_INTERFACE)
     if(${_build_type} STREQUAL "dll_dep")
       # This target depends on the DLL. When adding dependencies to this target,
