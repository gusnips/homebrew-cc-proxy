class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.14"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.14/cc-proxy-darwin-arm64.tar.gz"
      sha256 "27417fc7fefd95a475de982ba887010d901cee41f6f5d2c2b89066bb5c2b9548"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.14/cc-proxy-darwin-amd64.tar.gz"
      sha256 "d1de2a56930e212592451b68125b644ed825f1b957f311c71d8ecbd1b74a6b20"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.14/cc-proxy-linux-arm64.tar.gz"
      sha256 "2ae8762eb3141379db8734e2bfe97ded020acb4ece76dcd037edc20d9d2781b9"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.14/cc-proxy-linux-amd64.tar.gz"
      sha256 "f7ada5b524a3ac1ecd5b198c56ef417408c29b6cfa14714d3e545d9f0ac6c219"
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
