class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.8"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.8/cc-proxy-darwin-arm64.tar.gz"
      sha256 "631c7f48cb65dd451cc4c0f0745343955702dedc42319ed8ef493af31f253f19"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.8/cc-proxy-darwin-amd64.tar.gz"
      sha256 "4308f8481fe361ca710bc57067e8441172a7b1e2c3e4f7543cb48c7608de7a57"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.8/cc-proxy-linux-arm64.tar.gz"
      sha256 "85dbf3604007a5361ac2263831e5ec6de774842bb0c8fef3e2d12125b3f63024"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.8/cc-proxy-linux-amd64.tar.gz"
      sha256 "0952d16add5b1d602e2d296f39889d6f7c46f116c424ff38a489a43773955a78"
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
