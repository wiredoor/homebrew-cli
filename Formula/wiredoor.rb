class Wiredoor < Formula
  desc "Command-line client for managing Wiredoor"
  homepage "https://github.com/wiredoor/wiredoor-cli"
  license "Apache-2.0"

  depends_on "wireguard-tools"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.3/wiredoor_1.2.3_darwin_arm64.tar.gz"
      sha256 "6838499a75ed7adb30e50c65be54a01021fd0e35053c753997046239bbf877e1"
    else
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.3/wiredoor_1.2.3_darwin_amd64.tar.gz"
      sha256 "58d9faea083a75092049783d12f85c4a7d0925c02a04bb01a61389d3c9aa0866"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.3/wiredoor_1.2.3_linux_arm64.tar.gz"
      sha256 "7a4d5c4d69808c5a66c38163f17ab8f83fb280a627e5e51c5d4918c233a18b51"
    else
      url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.3/wiredoor_1.2.3_linux_amd64.tar.gz"
      sha256 "4d6060589bef359ceb0a517ea1f7d2b94967a323a9be30903642d1b8a87de4de"
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
