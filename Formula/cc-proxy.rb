class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.52"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.52/cc-proxy-darwin-arm64.tar.gz"
      sha256 "dbdfbc9039faaa73a2bf5c798ee69b4e1a625413040e2a00601e292bc3426b49"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.52/cc-proxy-darwin-amd64.tar.gz"
      sha256 "2c116c02525b7cec883e2a5236f0791d4ca1c7cd05387e26aec6adc6de4e4155"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.52/cc-proxy-linux-arm64.tar.gz"
      sha256 "050ed31b812cfb05473f8f81494823c910ca674b51767954abf971cccc4adc56"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.52/cc-proxy-linux-amd64.tar.gz"
      sha256 "68bac23a529b82e3df1c04691d164088e975a8266422e4be8d3dfbe4c079d07c"
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
