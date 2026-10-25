class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.3.3"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.3/cc-proxy-darwin-arm64.tar.gz"
      sha256 "fe6a9e1c8f15e6adfbf71727e0eb858b0cb3e02dafd4cb49a99c4b7fcc8383c3"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.3/cc-proxy-darwin-amd64.tar.gz"
      sha256 "536b1a0fcc4e63c14075029aeaeaaeb71ed394b172593836f8b141e2c6b9f84f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.3/cc-proxy-linux-arm64.tar.gz"
      sha256 "7a80134a9f35ba2d42fa0f7fcf47b6b2ec2ee6be1d00ad4eee2726346d1482f8"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.3/cc-proxy-linux-amd64.tar.gz"
      sha256 "7a5ac2495eb5f204c07c119d32df9fec32abe5ae97bee18b1c4a5ee6828c2c96"
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
