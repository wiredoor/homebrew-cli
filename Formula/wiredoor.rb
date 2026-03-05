class Wiredoor < Formula
  desc "Command-line client for managing Wiredoor"
  homepage "https://github.com/wiredoor/wiredoor-cli"
  version "1.2.0"
  license "Apache-2.0"

  depends_on "wireguard-tools"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0_darwin_arm64.tar.gz"
      sha256 "65a8250f633ecc87a28e413c70e7602d3ddde3272c5b0e2553c795b730794ad0"
    else
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0_darwin_amd64.tar.gz"
      sha256 "a5917889fdbb23a4e90d9a5c8a9aeada1b22eeb0019b6856b3bdf9c1816751a9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0_linux_arm64.tar.gz"
      sha256 "ef988485308baf5c7b571a2037f8234a07d31cc2ef6aa704c93be5ce5b8d85f8"
    else
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0_linux_amd64.tar.gz"
      sha256 "910780b22adcdd2cb6fe3c17ada067eacd65ad7150bd3adb7fde55dbcbb2ca66"
    end
  end

  def install
    bin.install "wiredoor"
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
