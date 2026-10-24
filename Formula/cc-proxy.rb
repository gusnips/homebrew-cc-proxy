class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.17"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.17/cc-proxy-darwin-arm64.tar.gz"
      sha256 "378789c7959e4da8236a7c191b5d064c1a64f49492f84ad3b8e793c164b5c4e0"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.17/cc-proxy-darwin-amd64.tar.gz"
      sha256 "7231835905a20a19c02a16abd184882017d13e786c8ec648bc014c22c06086f2"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.17/cc-proxy-linux-arm64.tar.gz"
      sha256 "2b256a6f22500cee4607d5a85dec0e5cbe6bf4b2033250b9e7ce035f141f2118"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.17/cc-proxy-linux-amd64.tar.gz"
      sha256 "979a09b8723b1ac9942df7db03829d94c74229bb640a221932e0ccf0bfe41f6a"
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
