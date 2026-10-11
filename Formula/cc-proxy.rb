class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.55"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.55/cc-proxy-darwin-arm64.tar.gz"
      sha256 "68f5edaad508a606c95b08be4a5c924daee97dbd02b1127249734afbc0dc4fa2"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.55/cc-proxy-darwin-amd64.tar.gz"
      sha256 "246974a8cdb7026d5fc3b4bd95e1c41f3fac9038f2af715dde4dd9bf57c2e81b"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.55/cc-proxy-linux-arm64.tar.gz"
      sha256 "80af8ae9408318fa233db97a2154ebea943947b6b28ab71b5569a219f5ffb67b"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.55/cc-proxy-linux-amd64.tar.gz"
      sha256 "07c2e748b8175e04b5c28b47530d77603b9903cd5f45030bed52f54801d2b967"
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
