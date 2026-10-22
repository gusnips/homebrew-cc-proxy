class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.12"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.12/cc-proxy-darwin-arm64.tar.gz"
      sha256 "d4872e2cd80d5f105f3627d7cd591cb7352c5348cf8148aadddaae45190db15b"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.12/cc-proxy-darwin-amd64.tar.gz"
      sha256 "7b35b1f3349788bb377d0b9c4021adf507e120bc4f300abf3c27709f231a084a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.12/cc-proxy-linux-arm64.tar.gz"
      sha256 "6378d8ee1d38ddc21028b933ca9d1e3e403d02f4fc7fd14898618e7ec013a54f"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.12/cc-proxy-linux-amd64.tar.gz"
      sha256 "734b881c9de6c30d962eda8f033e1bdce7663a3958a568f8211b7c9c6ec5eb23"
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
