class Qtkeychain < Formula
  desc "Platform-independent Qt API for storing passwords securely"
  homepage "https://github.com/frankosterfeld/qtkeychain"
  url "https://github.com/frankosterfeld/qtkeychain/archive/v0.12.0.tar.gz"
  sha256 "cc547d58c1402f6724d3ff89e4ca83389d9e2bdcfd9ae3d695fcdffa50a625a8"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_big_sur: "61f29925d6d5e1bf782025c65973a2ee5f9fcb05d5a9d6dc72c5bb409a335d10"
    sha256 cellar: :any, big_sur:       "09f89477a5fa66959801037615fe6c9319a1fff18727d9afac6594e3cc23bde5"
    sha256 cellar: :any, catalina:      "473370be4a7aec5d807ab8f17b75555939b5dc6cf38fb9d2b038349b04ca9c79"
    sha256 cellar: :any, mojave:        "ba63b7080abeab28a37b0e49bf5ded80d67f931020117386285c94dd4090f995"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  def install
    system "cmake", ".", "-DBUILD_TRANSLATIONS=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <qt5keychain/keychain.h>
      int main() {
        QKeychain::ReadPasswordJob job(QLatin1String(""));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11", "-I#{include}",
                    "-L#{lib}", "-lqt5keychain",
                    "-I#{Formula["qt@5"].opt_include}",
                    "-F#{Formula["qt@5"].opt_lib}", "-framework", "QtCore"
    system "./test"
  end
end
