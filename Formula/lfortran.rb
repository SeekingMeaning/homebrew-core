class Lfortran < Formula
  include Language::Python::Virtualenv

  desc "Modern interactive LLVM-based Fortran compiler"
  homepage "https://lfortran.org/"
  url "https://lfortran.github.io/tarballs/release/lfortran-0.2.0.tar.gz"
  sha256 "729b38269b1c933f3b2dc9253e1fab7e7aec4206d518e9cf007b171da5af53c3"
  license "BSD-3-Clause"

  depends_on "cmake" => :build
  depends_on "llvm@9"
  depends_on "python"

  # scikit-build start
  resource "scikit-build" do
    url "https://files.pythonhosted.org/packages/71/02/1e94506b7bee5739317f2d141cebab7dab5bb5731b377e718fddd3b3e7e7/scikit-build-0.11.1.tar.gz"
    sha256 "da40dfd69b2456fad1349a894b90180b43712152b8a85d2a00f4ae2ce8ac9a5c"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a6/a4/75064c334d8ae433445a20816b788700db1651f21bdb0af33db2aab142fe/distro-1.5.0.tar.gz"
    sha256 "0e58756ae38fbd8fc3020d54badb8eae17c5b9dcbed388b17bb55b8a5928df92"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/75/28/521c6dc7fef23a68368efefdcd682f5b3d1d58c2b90b06dc1d0b805b51ae/wheel-0.34.2.tar.gz"
    sha256 "8788e9155fe14f54164c1b9eb0a319d98ef02c160725587ad60f14ddc57b6f96"
  end
  # scikit-build end

  resource "antlr4-python3-runtime" do
    url "https://files.pythonhosted.org/packages/29/14/8ac135ec7cc9db3f768e2d032776718c6b23f74e63543f0974b4873500b2/antlr4-python3-runtime-4.7.2.tar.gz"
    sha256 "168cdcec8fb9152e84a87ca6fd261b3d54c8f6358f42ab3b813b14a7193bb50b"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/e2/ae/0b037584024c1557e537d25482c306cf6327b5a09b6c4b893579292c1c38/importlib_metadata-1.7.0.tar.gz"
    sha256 "90bb658cdbbf6d1735b6341ce708fc7024a3e14e99ffdc5783edea9f9b077f83"
  end

  resource "llvmlite" do
    url "https://files.pythonhosted.org/packages/71/4e/b1086722f4fa0b52cf8c0d4b2c985fb3f95d2f1be1b010259497b2464c1d/llvmlite-0.33.0.tar.gz"
    sha256 "9c8aae96f7fba10d9ac864b443d1e8c7ee4765c31569a2b201b3d0b67d8fc596"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/67/4a/16cb3acf64709eb0164e49ba463a42dc45366995848c4f0cf770f57b8120/more-itertools-8.4.0.tar.gz"
    sha256 "68c70cc7167bdf5c7c9d8f6954a7837089c6a36bf565383919bb595efb8a17e5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f8/04/7a8542bed4b16a65c2714bf76cf5a0b026157da7f75e87cc88774aa10b14/pluggy-0.13.1.tar.gz"
    sha256 "15b2acde666561e1298d71b523007ed7364de07029219b604cf808bfa1c765b0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/69/19/3aa4bf17e1cbbdfe934eb3d5b394ae9a0a7fb23594a2ff27e0fdaf8b4c59/prompt_toolkit-3.0.5.tar.gz"
    sha256 "563d1a4140b63ff9dd587bda9557cffb2fe73650205ab6f4383092fb882e7dc8"
  end

  resource "py" do
    url "https://files.pythonhosted.org/packages/97/a6/ab9183fe08f69a53d06ac0ee8432bc0ffbb3989c575cc69b73a0229a9a99/py-1.9.0.tar.gz"
    sha256 "9ca6883ce56b4e8da7e79ac18787889fa5206c79dcc67fb065376cd2fe03f342"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/6e/4d/4d2fe93a35dfba417311a4ff627489a947b01dc0cc377a3673c00cf7e4b2/Pygments-2.6.1.tar.gz"
    sha256 "647344a061c249a3b74e230c739f434d7ea4d8b1d5f3721bc0f3558049b38f44"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/8f/c4/e4a645f8a3d6c6993cb3934ee593e705947dfafad4ca5148b9a0fde7359c/pytest-5.4.3.tar.gz"
    sha256 "7979331bfcba207414f5e1263b5a0f8f521d0f457318836a7355531ed1a4c7d8"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/ce/8c/2c5f7dc1b418f659d36c04dec9446612fc7b45c8095cc7369dd772513055/zipp-3.1.0.tar.gz"
    sha256 "c599e4d75c98f6798c509911d08a22e6c021d074469042177c8c86fb92eefd96"
  end

  def install
    virtualenv_install_with_resources
    xy = Language::Python.major_minor_version Formula["python"].opt_bin/"python3"
    ln_s libexec/"share", libexec/"lib/python#{xy}/site-packages/share"
  end

  test do
    (testpath/"hello.f90").write <<~EOS
      program hello
        print *, "Hello World!"
      end program hello
    EOS
    system bin/"lfort", "-emit-llvm", "hello.f90"
    clang = Formula["llvm@9"].bin/"clang"
    system clang, "-L#{libexec}/share/lfortran/lib", "-llfortran_runtime", "-o", "hello", "hello.ll"
    assert_match "Hello World!", shell_output("./hello")
  end
end
