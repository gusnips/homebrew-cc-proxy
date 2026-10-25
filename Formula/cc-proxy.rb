class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.0"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.0/cc-proxy-darwin-arm64.tar.gz"
      sha256 "23dff09ad63549b57e4840be0890f557d3531e8dafd84b03ba62228c2fef1245"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.0/cc-proxy-darwin-amd64.tar.gz"
      sha256 "18c54d34b03b48bc70fd5d0b3c66531e1964c1011567d4d85a35f0171ab3a7a8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.0/cc-proxy-linux-arm64.tar.gz"
      sha256 "65354f4dbe066348882bb642bac016ffee21a1115f3dfdfe9bd8cd065fa82060"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.0/cc-proxy-linux-amd64.tar.gz"
      sha256 "e853cee2997bbadfc7f2c01de650104f848b79ce806360773b514353ebc2f398"
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
