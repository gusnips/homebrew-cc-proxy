class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.43"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-darwin-arm64.tar.gz"
      sha256 "REPLACE_WITH_RELEASE_SHA256"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-darwin-amd64.tar.gz"
      sha256 "REPLACE_WITH_RELEASE_SHA256"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-linux-arm64.tar.gz"
      sha256 "REPLACE_WITH_RELEASE_SHA256"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-linux-amd64.tar.gz"
      sha256 "REPLACE_WITH_RELEASE_SHA256"
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
