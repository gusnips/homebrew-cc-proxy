class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.14"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.14/cc-proxy-darwin-arm64.tar.gz"
      sha256 "d082b28501d2666876baebdaeafe87ff4abefabd8453ac529b2cb4fd665d6e84"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.14/cc-proxy-darwin-amd64.tar.gz"
      sha256 "c94dc1fbb910f855540bb13c59ebc40517df61c870224cd1eaca922edcbb6b83"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.14/cc-proxy-linux-arm64.tar.gz"
      sha256 "e6813f2fa6fbb2ef29e579203e43304226588b9c72097ca9aec38913082c81c2"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.14/cc-proxy-linux-amd64.tar.gz"
      sha256 "aa8ccb32af690aca61ab9f0e3a3f4a194e457d090a60206e5bf64065e67c3aa6"
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
