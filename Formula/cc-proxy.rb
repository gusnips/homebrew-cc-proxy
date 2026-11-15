class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.16"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.16/cc-proxy-darwin-arm64.tar.gz"
      sha256 "d22d3eb52a0b00ceeeadac834c48e2277d5b28c9072b4b523246f74f2cc93dda"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.16/cc-proxy-darwin-amd64.tar.gz"
      sha256 "822a8d896d1d8ea544ce3a598fabece30c661d26d8b14cc125151d08ff7f5a80"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.16/cc-proxy-linux-arm64.tar.gz"
      sha256 "c7698d1ad52a405f45c2c5217481ffaec3e52a1c115f7e31a39f3cc14a78af2f"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.16/cc-proxy-linux-amd64.tar.gz"
      sha256 "9aee75a56f6ac6f09266571b4a2f3d3328dbed825d8859f9230b16a884d60dae"
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
