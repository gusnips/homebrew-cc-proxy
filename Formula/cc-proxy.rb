class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.10"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.10/cc-proxy-darwin-arm64.tar.gz"
      sha256 "04dd6b34345e0854b9a442d676ba99ca81db3e778bb15625c7960f2385747bfb"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.10/cc-proxy-darwin-amd64.tar.gz"
      sha256 "dc8724d730044de6a6845429e5d9b19b5b702aec5859293ba8d34a1b64c4a237"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.10/cc-proxy-linux-arm64.tar.gz"
      sha256 "0d68ef10a34974067ba7525df6305ae4f53903cbc09fc5640926a64d4f96beb3"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.10/cc-proxy-linux-amd64.tar.gz"
      sha256 "7a2e66b896d7d772d2a9a3fd441eb9f9a19e2d75e833a05efdbe7c60b53d3c92"
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
