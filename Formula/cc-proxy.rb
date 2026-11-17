class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.17"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.17/cc-proxy-darwin-arm64.tar.gz"
      sha256 "0055dd885a34fbef9ce47cbe68a3135ffd717a5092951057be593e4ec86b8a92"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.17/cc-proxy-darwin-amd64.tar.gz"
      sha256 "62570d277f634ba5d88c530b30c2f5d35421a19553e22014d2919b44e212661c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.17/cc-proxy-linux-arm64.tar.gz"
      sha256 "9be902b4057e3dbaf7a8030cd4e36362bebbe76b45d7f3fe781d30ec31c31122"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.17/cc-proxy-linux-amd64.tar.gz"
      sha256 "0ef560422b27077869ce50bdfcc06b57b622e668b458166ecca5f2e615f78b92"
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
