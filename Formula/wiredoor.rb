class Wiredoor < Formula
  desc "Wiredoor CLI"
  homepage "https://github.com/wiredoor/wiredoor-cli"
  version "1.0.0"
  license "Apache-2.0"
  
  # https://github.com/wiredoor/wiredoor-cli/releases/download/v1.1.4/wiredoor_1.1.4-1_alpine_amd64.apk
  on_macos do
    if Hardware::CPU.arm?
    #   url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0-1_darwin_arm64.tar.gz"
      url "file:///Users/dmesa/Downloads/wiredoor_1.0.0_darwin_arm64.tar.gz"
      sha256 "1d2221945b0cec87d0811785193e3e4323b29f8500e70bd0e6df40b5e53704cd"
    else
    #   url "https://github.com/wiredoor/wiredoor-cli/releases/download/v1.2.0/wiredoor_1.2.0-1_darwin_amd64.tar.gz"
      url "file:///Users/dmesa/Downloads/wiredoor_1.0.0_darwin_amd64.tar.gz"
      sha256 "b1431bc1ab23ae4b864ff2916a14414beff7ab121397dd50217b5bace2f6242d"
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