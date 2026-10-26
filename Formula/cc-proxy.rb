class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.4"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.4/cc-proxy-darwin-arm64.tar.gz"
      sha256 "582b357968625d9168d34e535d35be8b45375e935a8fd496b2f69287de921328"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.4/cc-proxy-darwin-amd64.tar.gz"
      sha256 "f52a2aaa5e1c354a1949d12faa0c03fd0dd2a32f81546ee04bed703d4b23dde7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.4/cc-proxy-linux-arm64.tar.gz"
      sha256 "5e4017e6840d07999ceab6e03fd88494c026e4acf09c15ae83408e09c0943b02"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.4/cc-proxy-linux-amd64.tar.gz"
      sha256 "38f35ba82388884c17fc29f8ad7f243700a334881d37e57e491e2f792d85cf8a"
    end
  end

  def install
    bin.install "cc-proxy"
  end

  service do
    state_home = ENV.fetch("XDG_STATE_HOME", "#{Dir.home}/.local/state")

    run [opt_bin/"cc-proxy", "start", "--no-monitor"]
    keep_alive true
    environment_variables XDG_STATE_HOME: state_home
    log_path "#{state_home}/cc-proxy/service.log"
    error_log_path "#{state_home}/cc-proxy/service.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-proxy --version")
  end
end
