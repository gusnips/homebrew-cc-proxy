class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.49"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.49/cc-proxy-darwin-arm64.tar.gz"
      sha256 "e82c843604fb38352ef3250d923310f5f6c782e568fdeaea746e5e5d8c6846af"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.49/cc-proxy-darwin-amd64.tar.gz"
      sha256 "e62aa7f960b76e4b86d57b8b3b112393ac8d4c4d7a9af5c37a0dc90a80a0bbaf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.49/cc-proxy-linux-arm64.tar.gz"
      sha256 "1d778d0c45aa4382ddfeec92ec976068ffefd98b4de6cbb7a7268fe89538948f"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.49/cc-proxy-linux-amd64.tar.gz"
      sha256 "d45ae390c6a61fd802c24bd53a09c3588c58b2c85011af6c0a87d07e1bd332e6"
    end
  end

  def install
    bin.install "cc-proxy"
  end

  service do
    state_home = ENV.fetch("XDG_STATE_HOME", "#{Dir.home}/.local/state")

    run [opt_bin/"cc-proxy", "serve", "--no-monitor"]
    keep_alive true
    environment_variables XDG_STATE_HOME: state_home
    log_path "#{state_home}/cc-proxy/service.log"
    error_log_path "#{state_home}/cc-proxy/service.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc-proxy --version")
  end
end
