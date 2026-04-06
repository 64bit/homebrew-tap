class Commandok < Formula
  desc "Spotlight-like command generator for your terminal, powered by LLMs"
  homepage "https://github.com/64bit/commandOK"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.2/commandok-aarch64-apple-darwin.tar.xz"
      sha256 "ba135a3d9ad58458f3cfc58c8919ac49bcc9f34948eaf5bbc2b2e038e34a80fe"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.2/commandok-x86_64-apple-darwin.tar.xz"
      sha256 "303f52af7b54d36dc2b9e0eafbdc0aa0c0f9a37bfb4a66b51d06c7d8d2f4e2c3"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.2/commandok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ad55be3a35b8c8c2c31a7733d505ac2b20b0d1354a2d09f72bc53a0462fd930"
    end
    if Hardware::CPU.intel?
      url "https://github.com/64bit/commandOK/releases/download/v0.1.2/commandok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "52a19766854fa8b4882a0863e19d3f547838a57148b6cdddedcce67b947ad956"
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
