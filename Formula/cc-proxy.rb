class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.53"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.53/cc-proxy-darwin-arm64.tar.gz"
      sha256 "40fb62b7ae4bce1be50bdf5bb3a6d02bd3e3b93ae6d9411cc5fcda0d8280be99"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.53/cc-proxy-darwin-amd64.tar.gz"
      sha256 "d9f74a600f09ded34f05f5fb91534c784811e084517b001f1b9960170a52c905"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.53/cc-proxy-linux-arm64.tar.gz"
      sha256 "333aaa9caefbf41c17d3e591ed3dc3cf3b3917f109e6367623a8a708ebc330bc"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.53/cc-proxy-linux-amd64.tar.gz"
      sha256 "cee6a5a2451988a9e6071a72f379b0c93a8547f65f25a5c7847ed31b89b0c488"
    end
  end

  def install
    bin.install "cc-proxy"
  end

  service do
    state_home = ENV.fetch("XDG_STATE_HOME", "#{Dir.home}/.local/state")

    run [opt_bin/"cc-proxy", "serve", "--no-monitor"]
    keep_alive true
    environment_variables XDG_STATE_HOME: state_home
    log_path "#{state_home}/cc-proxy/service.log"
    error_log_path "#{state_home}/cc-proxy/service.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-proxy --version")
  end
end
