class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.0"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.0/cc-proxy-darwin-arm64.tar.gz"
      sha256 "cd039f99a5d646794bbec522ac8cc410ef0d3ece9c63828da444d42aea9ff1f8"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.0/cc-proxy-darwin-amd64.tar.gz"
      sha256 "43cbbc078f473ff7d4b858c4c5009234c3a122d692d6dcfbf5238b21bc0e4f25"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.0/cc-proxy-linux-arm64.tar.gz"
      sha256 "83118a22806a6edcdeecead48e42fbe33f674fe4fea00a1bf967c7a155406928"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.0/cc-proxy-linux-amd64.tar.gz"
      sha256 "fa06a41c2f2b019f4036cac345736884677648b89de8a65b94c021e571187f25"
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
