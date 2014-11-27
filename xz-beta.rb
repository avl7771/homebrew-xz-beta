require "formula"

class XzBeta < Formula
  homepage "http://tukaani.org/xz/"
  url "http://tukaani.org/xz/xz-5.1.4beta.tar.gz"
  sha256 "7c47b9e2cfb5be93245d9fcf2bec5b459412b7628c333896dded373dcd0cf0e0"

  conflicts_with 'xz', :because => 'both install xz binaries'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"data.txt"
    original_contents = "." * 1000
    path.write original_contents

    # compress: data.txt -> data.txt.xz
    system bin/"xz", path
    assert !path.exist?

    # decompress: data.txt.xz -> data.txt
    system bin/"xz", "-d", "#{path}.xz"
    assert_equal original_contents, path.read
  end
end
