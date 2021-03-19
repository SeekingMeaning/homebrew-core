class Flow < Formula
  desc "Static type checker for JavaScript"
  homepage "https://flowtype.org/"
  url "https://github.com/facebook/flow/archive/v0.147.0.tar.gz"
  sha256 "a95a28b2e5e7b6c0cdec781954c036798616c584e6ddfd6e51b17f17037ead31"
  license "MIT"
  head "https://github.com/facebook/flow.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "4617d363d6b19ced297c2036bdc1c9d71b37fccb904d4cb5d3a89375fdb74abb"
    sha256 cellar: :any_skip_relocation, catalina: "ae76a599f9cc1bcf2f8bdb249a9347a9c488a987ac7ebe2e3a1aa24e9b3fb412"
    sha256 cellar: :any_skip_relocation, mojave:   "68677edaf1b704689b0a1e9d53a55e5b20fb163b362eab0569c55c730409d503"
  end

  depends_on "ocaml" => :build
  depends_on "opam" => :build

  uses_from_macos "m4" => :build
  uses_from_macos "rsync" => :build
  uses_from_macos "unzip" => :build

  if Hardware::CPU.arm?
    # Update ocaml to 4.10.2 for darwin-arm64 compatibility
    # https://github.com/facebook/flow/pull/8616
    patch :DATA
  end

  def install
    system "make", "all-homebrew"

    bin.install "bin/flow"

    bash_completion.install "resources/shell/bash-completion" => "flow-completion.bash"
    zsh_completion.install_symlink bash_completion/"flow-completion.bash" => "_flow"
  end

  test do
    system "#{bin}/flow", "init", testpath
    (testpath/"test.js").write <<~EOS
      /* @flow */
      var x: string = 123;
    EOS
    expected = /Found 1 error/
    assert_match expected, shell_output("#{bin}/flow check #{testpath}", 2)
  end
end
__END__
diff --git a/Makefile b/Makefile
index 5465d184940946b3f27693aa2fb198e71bacc2fe..48db2ba27a53e6777de26709d6cd0f9e2f42cbd7 100644
--- a/Makefile
+++ b/Makefile
@@ -326,7 +326,7 @@ all-homebrew:
 	export FLOW_RELEASE="1"; \
 	opam init --bare --no-setup --disable-sandboxing && \
 	rm -rf _opam && \
-	opam switch create . --deps-only ocaml-base-compiler.4.09.1 && \
+	opam switch create . --deps-only ocaml-base-compiler.4.10.2 && \
 	opam exec -- make
 
 clean:
diff --git a/flow_parser.opam b/flow_parser.opam
index 11943c4013cf52523b327c57c00b7b2710dde9ba..d42ccc976d2e29600eb4f33dcea4b6a2f299c0d5 100644
--- a/flow_parser.opam
+++ b/flow_parser.opam
@@ -10,7 +10,7 @@ license: "MIT"
 build: [ make "-C" "src/parser" "build-parser" ]
 install: [ make "-C" "src/parser" "ocamlfind-install"]
 depends: [
-  "ocaml" {>= "4.09.1"}
+  "ocaml" {>= "4.10.2"}
   "ocamlfind" {build}
   "ocamlbuild" {build}
   "ppx_deriving" {build}
diff --git a/flowtype.opam b/flowtype.opam
index 30fc7723b7687de974ebf889d47dfdb446cde937..c360de6dc5dd953e8fbc366443d9de9995711e7d 100644
--- a/flowtype.opam
+++ b/flowtype.opam
@@ -8,8 +8,8 @@ homepage: "https://flow.org"
 doc: "https://flow.org/en/docs/getting-started/"
 bug-reports: "https://github.com/facebook/flow/issues"
 depends: [
-  "ocaml" {>= "4.09.1"}
-  "base" {= "v0.12.2"}
+  "ocaml" {>= "4.10.2"}
+  "base" {= "v0.14.0"}
   "base-unix"
   "base-bytes"
   "dtoa" {>= "0.3.1"}
diff --git a/src/codemods/utils/codemod_runner.mli b/src/codemods/utils/codemod_runner.mli
index b329e15e87fb689acb476e86b50feea50697ffb7..24669186ceac2b0b7a931c3ec65870861c579cb8 100644
--- a/src/codemods/utils/codemod_runner.mli
+++ b/src/codemods/utils/codemod_runner.mli
@@ -5,6 +5,7 @@
  * LICENSE file in the root directory of this source tree.
  *)
 
+[@@@ocaml.warning "-67"]
 type 'a unit_result = ('a, ALoc.t * Error_message.internal_error) result
 
 type ('a, 'ctx) abstract_visitor = (Loc.t, Loc.t) Flow_ast.Program.t -> 'ctx -> 'a
diff --git a/src/parser_utils/output/js_layout_generator.ml b/src/parser_utils/output/js_layout_generator.ml
index 4c5a72057466d11d4de3a8d093ac58bc58219cdd..a981e5084f4ccd6363aaf92764608a4799fb2bc0 100644
--- a/src/parser_utils/output/js_layout_generator.ml
+++ b/src/parser_utils/output/js_layout_generator.ml
@@ -5,6 +5,7 @@
  * LICENSE file in the root directory of this source tree.
  *)
 
+[@@@ocaml.warning "-60"]
 module Ast = Flow_ast
 open Layout
 
diff --git a/src/parser_utils/type_sig/type_sig_parse.ml b/src/parser_utils/type_sig/type_sig_parse.ml
index 68343bc54dc8dde769fc614998d369f7de274375..fb8dbfb7c62f38f8dae60c115327ffeebb1fc9f9 100644
--- a/src/parser_utils/type_sig/type_sig_parse.ml
+++ b/src/parser_utils/type_sig/type_sig_parse.ml
@@ -3183,6 +3183,7 @@ let rec member_expr_of_generic_id scope locs chain =
       (val_ref scope ref_loc name)
       chain
 
+[@@@ocaml.warning "-60"]
 let declare_class_def =
   let module O = Ast.Type.Object in
   let module Acc = DeclareClassAcc in
