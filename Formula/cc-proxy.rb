class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.3.2"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.2/cc-proxy-darwin-arm64.tar.gz"
      sha256 "35131e6613453f140cf72231c88d600a65f44173516fd0ce394484c7edfbd9ec"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.2/cc-proxy-darwin-amd64.tar.gz"
      sha256 "57535d8e8cd17e91fbd2385df1011bed4f000ef206ce4eb384bdf34fcc749668"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.2/cc-proxy-linux-arm64.tar.gz"
      sha256 "b05ae6099089bd3b0bbc95d57c50b8238bc7a93e9a64d25628d42251d9fad0eb"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.2/cc-proxy-linux-amd64.tar.gz"
      sha256 "2fa68283a77196d57be2a51b7ac1b915b60a4439d2199de2b3cb42cad7db8590"
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
