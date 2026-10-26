class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.2"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.2/cc-proxy-darwin-arm64.tar.gz"
      sha256 "f5b56331ad3e69987d8f82c84db67ed81f61750df805e63ada96645ca211dfd8"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.2/cc-proxy-darwin-amd64.tar.gz"
      sha256 "c69ff0c67df87235894abefb5c569ed111a425427874c68a22fe7615e0af369d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.2/cc-proxy-linux-arm64.tar.gz"
      sha256 "efdfa9c54506012a5f945aefc4781be9957426d2d7eda902fd358c25e912d290"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.2/cc-proxy-linux-amd64.tar.gz"
      sha256 "e506d60db842e9f66d0d1550796cb10069ec593ff2b543580a5d34c6a23cd2e6"
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
