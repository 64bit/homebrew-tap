class Commandok < Formula
  desc "Spotlight-like command generator for your terminal, powered by LLMs"
  homepage "https://github.com/64bit/commandOK"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.3/commandok-aarch64-apple-darwin.tar.xz"
      sha256 "e8dc2943e3ed828cf1148c9f033d4e72b88831ef648f4259eaed1257ca756b4d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.3/commandok-x86_64-apple-darwin.tar.xz"
      sha256 "b3a8358338b3a9e351f72d3f381794111d1e71b028af2d7f7a39ded55b4a38d7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.3/commandok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43d0025e051abfa2394a2ad23fa91fb86e3109f09ce72c12eaff285a2ab504fa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.3/commandok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6eefd7825c1f6f910adf5a54c617d5ced052509f1911fd5a09615f7fdf1d9b3c"
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
