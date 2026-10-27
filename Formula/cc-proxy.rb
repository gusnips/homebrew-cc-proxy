class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.7"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.7/cc-proxy-darwin-arm64.tar.gz"
      sha256 "78c5babe52fc5936692cc4a5edb1e2a561783cec931b13e2ed39d5252df13a74"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.7/cc-proxy-darwin-amd64.tar.gz"
      sha256 "269ffa35f6845d8763bd21ecd710b4ad837631c85686c2162a4f2cbf91629fa0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.7/cc-proxy-linux-arm64.tar.gz"
      sha256 "634362bd41308248e99de5156f4ced2f13bec5a39b7f08b9ab95fffcc39601d3"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.7/cc-proxy-linux-amd64.tar.gz"
      sha256 "5d7837f7be9974172a98f7b807d49441f10cebb59d376638b6d9fe1bf54571af"
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
