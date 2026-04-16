class Commandok < Formula
  desc "Spotlight-like command generator for your terminal, powered by LLMs"
  homepage "https://github.com/64bit/commandOK"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.5/commandok-aarch64-apple-darwin.tar.xz"
      sha256 "b895cb78f0ac55c89fd0f8badace9ecf49e68874c920692fce50190c2cf913f8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.5/commandok-x86_64-apple-darwin.tar.xz"
      sha256 "06ea892e577f9b1de2be6c049945ee9861aac797fce39a7d24969970c4623ed8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.5/commandok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "df3e68aef368f678f1c429c2f5446588926682e59ab4a3a7a26f208426d3a892"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.5/commandok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6140b3c9892f2c022247cec8e9b665c8fedd95c31559933360f7e12e5f5a09fe"
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
