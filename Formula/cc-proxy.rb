class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.3"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.3/cc-proxy-darwin-arm64.tar.gz"
      sha256 "4b24a1d0be6cca4d18b11716f93c765cf7bce06913d84dd497500500e6f6b27f"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.3/cc-proxy-darwin-amd64.tar.gz"
      sha256 "2243b6c2ba96d1079893c64ab4ab709657c4a0c3b44b766cda36c3e22932e50a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.3/cc-proxy-linux-arm64.tar.gz"
      sha256 "d4a4e5ba7d34507a9e932c044a2ef767f9441d3141125d4d224a2ce01d62c433"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.3/cc-proxy-linux-amd64.tar.gz"
      sha256 "4f7d0c4a1e7c28aeb0edac830f38b1ac05751241b3a2a217596e728cb07cf153"
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
