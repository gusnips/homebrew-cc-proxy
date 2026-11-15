class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.15"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.15/cc-proxy-darwin-arm64.tar.gz"
      sha256 "e3b95b6d68277fb590a3ee673a226b53f8ae7c5ca51d11a49e8a6d0812290851"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.15/cc-proxy-darwin-amd64.tar.gz"
      sha256 "a2196e5fb2f8df40a530534d78cf280fd1014e96b00150f39acd09678098069c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.15/cc-proxy-linux-arm64.tar.gz"
      sha256 "22a06741ff37a481b9e8ff7cae62b3c8f6c39f2f658da8fe13c39f5e568cd1ff"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.15/cc-proxy-linux-amd64.tar.gz"
      sha256 "55d45856816b382557f18436c03d358afe6238ca252dcbfb910184593fe86123"
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
