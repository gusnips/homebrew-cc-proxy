class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.10"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.10/cc-proxy-darwin-arm64.tar.gz"
      sha256 "d2fee8c0d642bec5f26f7721d42275d3a87f8a8e1780bc17a7ff512434301395"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.10/cc-proxy-darwin-amd64.tar.gz"
      sha256 "d1e87eebea23e5fd578a6a2d19059e9caddba7cb245112ee2c6580f012d0c012"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.10/cc-proxy-linux-arm64.tar.gz"
      sha256 "f0d6f9fe882964c73056e730191c5ecdd37811656830d4da21a04f7df30b1066"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.10/cc-proxy-linux-amd64.tar.gz"
      sha256 "e6e46e4623050792286003edf09f3125e2ad393e9049418cb543d9fa126842a6"
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
