class Wiredoor < Formula
  desc "Command-line client for managing Wiredoor"
  homepage "https://github.com/wiredoor/wiredoor-cli"
  version "1.2.0"
  license "Apache-2.0"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0-1_darwin_arm64.tar.gz"
      sha256 "8563d375a0acfe9b6a4bdaaded0b5e5de08c577d58233ddd3a61bf6176225ddf"
    else
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0-1_darwin_amd64.tar.gz"
      sha256 "d0e29ebf1fafc2e720a34cc0137c4112f33be5a4bf6c0c05a27a25b2093737b1"
    end
  end

  depends_on "wireguard-tools"

  def install
    bin.install "wiredoor"
    # completions/manpages:
    man1.install Dir["man/*.1.gz"] if File.exist?("man/wiredoor.1.gz")
    bash_completion.install "completions/wiredoor.bash" if File.exist?("completions/wiredoor.bash")
    zsh_completion.install  "completions/_wiredoor" if File.exist?("completions/_wiredoor")
    fish_completion.install "completions/wiredoor.fish" if File.exist?("completions/wiredoor.fish")
  end

  service do
    run [opt_bin/"wiredoor", "status", "--watch", "--interval", "10"]
    keep_alive true
    log_path var/"log/wiredoor.log"
    error_log_path var/"log/wiredoor.err.log"
  end

  test do
    assert_match "wiredoor", shell_output("#{bin}/wiredoor --help")
  end
end