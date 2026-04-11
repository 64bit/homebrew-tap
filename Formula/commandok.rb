class Commandok < Formula
  desc "Spotlight-like command generator for your terminal, powered by LLMs"
  homepage "https://github.com/64bit/commandOK"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.4/commandok-aarch64-apple-darwin.tar.xz"
      sha256 "4f524a52ad2bb48a536a8d430ba01f0bf9db24374de9402a5def9150d116588b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.4/commandok-x86_64-apple-darwin.tar.xz"
      sha256 "3c5e20960572cc12914e78beb9c12967f8c7564b589ade087f155b8d05a745b2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.4/commandok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "dd65c920c47e1f269d3ecf901fe051e063b76797c6c6a303fe01e1b1c12757ee"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.4/commandok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5a7faa22951be17b80a28157c0df299e69b4c1eec7a1e873bb9e844b6f9c6fb1"
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
