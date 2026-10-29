class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.11"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.11/cc-proxy-darwin-arm64.tar.gz"
      sha256 "45d900163a35ee5e4c728c74906202e363db9291e812d7ab18234158b94211e0"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.11/cc-proxy-darwin-amd64.tar.gz"
      sha256 "ad2924a0d8e4210c330f8f78ebb9aaf86688ed4515678135059f2b9f79e0f970"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.11/cc-proxy-linux-arm64.tar.gz"
      sha256 "d99454aa4e8974c94c446be383a486a07a9eb3019799f88145e4b9b1846d4789"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.11/cc-proxy-linux-amd64.tar.gz"
      sha256 "ce385a93c774d2e532f15e53bad0686c348817ddee3d90cb4bd17b172c76d0f4"
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
