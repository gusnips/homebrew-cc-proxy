class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.11"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.11/cc-proxy-darwin-arm64.tar.gz"
      sha256 "847e40e6a0647cff1bbbc5dd6f2c772809572a4e2336ff75f23bb4a8b4681693"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.11/cc-proxy-darwin-amd64.tar.gz"
      sha256 "b1cae0c441fcc57d059c6b2b73dd304855eaa3fddbd3915f04cd89c13fa81dc6"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.11/cc-proxy-linux-arm64.tar.gz"
      sha256 "d5ed2d985a42bfcea5c1430e4c0241d7bbf2e7d79c72b7383c15e1c9aeba9d93"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.11/cc-proxy-linux-amd64.tar.gz"
      sha256 "4344c49998acccef0ce5a9a6d2bf0eda4c82a05130c487346416f22fa3b30da2"
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
