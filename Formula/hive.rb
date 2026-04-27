class Hive < Formula
  desc "Agent orchestration TUI for story-to-PR automation"
  homepage "https://hivemine-technologies.github.io/hive/"
  version "0.1.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/Hivemine-Technologies/hive/releases/download/v0.1.0/hive-aarch64-apple-darwin.tar.xz"
    sha256 "d2e4c9959159cf501c34f738f66174ae17b0de28af88b4a0c49d3e0af77cb36d"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/Hivemine-Technologies/hive/releases/download/v0.1.0/hive-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "1d5d8237df629c8af2652f3c7ea38c78564be8164587fc6d4d2f509ddaffb361"
  end
  license "LicenseRef-Proprietary"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":     {},
    "x86_64-unknown-linux-gnu": {},
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
    bin.install "hive" if OS.mac? && Hardware::CPU.arm?
    bin.install "hive" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
