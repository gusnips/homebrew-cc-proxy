class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.13"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.13/cc-proxy-darwin-arm64.tar.gz"
      sha256 "ec9d62b89d9b60b0d6e28c12fdfd4fcf6b455480a1fd0af3cfae47e408a2f27e"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.13/cc-proxy-darwin-amd64.tar.gz"
      sha256 "0d03b2ce219e71d3158e1aebe4b502fe1bca81552940bdfae5b50aa814a97e4d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.13/cc-proxy-linux-arm64.tar.gz"
      sha256 "e06bd4e09ec54391c82167555402d04f557d9a1d91ba32bdb9bf031cc4952566"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.13/cc-proxy-linux-amd64.tar.gz"
      sha256 "3362be4e0d32afe1dfeb1dbe29ee0dcab031f7575d37699b503ca9d3b3299afb"
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
