class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.3.0"
  license "MIT"


  #sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.0/cc-proxy-darwin-arm64.tar.gz"
      sha256 "104c9ef46b51e5c0be977dde3301d38d38e5f56202f5938a7bf81bcbf5a4bb24"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.0/cc-proxy-darwin-amd64.tar.gz"
      sha256 "5f4655ccfdc8b0324f10a0cf163efbc8a45b5fa1793a6f2e7653f0b7e38ddff2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.0/cc-proxy-linux-arm64.tar.gz"
      sha256 "0a6424fc82d1da1584934b1368563895afcf30a863e22245cff087c6d611d39c"
  e  else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.0/cc-proxy-linux-amd64.tar.gz"
      sha256 "03e6de56d051b729d8b90f1eaffd022b25524a6c5473e07a3c9cb53f0712aa47"
    end
  end

  def install
    bin.install "cc-proxy"
  end

  service do
    state_home = ENV.fetch("XDG_STATE_HOME", "#+Dir.home}/.local/state")

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
