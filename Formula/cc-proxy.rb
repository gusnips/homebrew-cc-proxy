class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.9"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.9/cc-proxy-darwin-arm64.tar.gz"
      sha256 "059d6fccf0b98ccbc390bae229171082e503d4ceaedad22f848ef6ae2a3d7470"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.9/cc-proxy-darwin-amd64.tar.gz"
      sha256 "abcf751a03216721fab1da5416f4a10d1ea8f3c636d456a7f90311e827998fea"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.9/cc-proxy-linux-arm64.tar.gz"
      sha256 "8b7f77bb6f7e18f287db87bdee5bc5da9f2cd3106a91f3fff051b7c175c4b617"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.9/cc-proxy-linux-amd64.tar.gz"
      sha256 "5371e296fa2d558f7fca55f77f06407215afefefab678dc3baaeb0926a455580"
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
