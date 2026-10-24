class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.3.1"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.1/cc-proxy-darwin-arm64.tar.gz"
      sha256 "94fbc0711ca98b0cad52cfacbeb2c57b17801f27532ce85f0cb5aa962b362d1c"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.1/cc-proxy-darwin-amd64.tar.gz"
      sha256 "203504a8861127004b3cd13432d08fe4bc49df4238d59b077df8d78ca33e0795"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.1/cc-proxy-linux-arm64.tar.gz"
      sha256 "7057807eede6be76549e51f29d4b0e1123e021ca0c8302cf31f30e73f701e6da"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.3.1/cc-proxy-linux-amd64.tar.gz"
      sha256 "7e78108868d61dbfbee6fd5bca147ffd476794f463787754eb0b72a3d5ded41d"
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
