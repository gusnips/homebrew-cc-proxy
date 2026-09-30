class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.43"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-darwin-arm64.tar.gz"
      sha256 "8ffd0f93006d0b634acdd60a813283507f7d48fa6dbeadcee6e52304555c9f04"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-darwin-amd64.tar.gz"
      sha256 "5c9f9db3ff1057bb224916a718108353d9d9db37201c6b50704c35878247c4f1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-linux-arm64.tar.gz"
      sha256 "0ca0aa92efc7425e80a8e4795ea7a441cf4c3925284a54e6a4e7f53cbfe5134b"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.43/cc-proxy-linux-amd64.tar.gz"
      sha256 "033fc6aecc3b36d630a9527072fd491815856c3952b4b88cd3ed519d402bec02"
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
