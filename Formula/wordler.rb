class Wordler < Formula
  desc "Library and cli for Wordle"
  homepage "https://docs.rs/wordler"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/wordle-rs/releases/download/v0.3.1/wordler-aarch64-apple-darwin.tar.xz"
      sha256 "f8785dd1f8235bbede90d6f8756b8bd5b50509889be752ed2902a18bb7eddafe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/wordle-rs/releases/download/v0.3.1/wordler-x86_64-apple-darwin.tar.xz"
      sha256 "5a69ea742b5a32e72e3b9c05a6ebb9def09a12e66fe3cc4045f2b8d95d138fc3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/wordle-rs/releases/download/v0.3.1/wordler-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cc2a8398920587110db29cb92580143fdccf41796515bbfb81a402a2f5123350"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/wordle-rs/releases/download/v0.3.1/wordler-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6016403d74a783b609a298b96d4e96e93a0d34f1be6a1d7104677fba83c489c4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wordler" if OS.mac? && Hardware::CPU.arm?
    bin.install "wordler" if OS.mac? && Hardware::CPU.intel?
    bin.install "wordler" if OS.linux? && Hardware::CPU.arm?
    bin.install "wordler" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
