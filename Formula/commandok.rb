class Commandok < Formula
  desc "Spotlight-like command generator for your terminal, powered by LLMs"
  homepage "https://github.com/64bit/commandOK"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.6/commandok-aarch64-apple-darwin.tar.xz"
      sha256 "f56e9b371293e6fdd7865f5cfee9a158fa866fb5af38b6800c019310ca3983b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.6/commandok-x86_64-apple-darwin.tar.xz"
      sha256 "1495f3a83b8e4b533df9d38c38d85232828391e670e729ee6f3204d31fae319c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.6/commandok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42c17be793c7f69429bf023e3e8f0a5bd3f7bd369530d90634025932f01b4ce2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.6/commandok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7139f38ab680a98ae88c71964d7a9fbd95579e8de80d7f0c4b06ad83d16c2504"
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
    bin.install "commandok" if OS.mac? && Hardware::CPU.arm?
    bin.install "commandok" if OS.mac? && Hardware::CPU.intel?
    bin.install "commandok" if OS.linux? && Hardware::CPU.arm?
    bin.install "commandok" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
