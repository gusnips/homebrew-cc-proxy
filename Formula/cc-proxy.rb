class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.18"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.18/cc-proxy-darwin-arm64.tar.gz"
      sha256 "8c0c7543900057fdeb2975c81952943dd8d915632b227f108e136f521bb62e75"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.18/cc-proxy-darwin-amd64.tar.gz"
      sha256 "370c8f8ae009ba02ab6788a887add4633c01d75f2e7c76d7ea521e97b9cc0a31"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.18/cc-proxy-linux-arm64.tar.gz"
      sha256 "61a8dee302ec5a2db91a26ca7d673f3b14964633f374f9511f829d8411aa8109"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.18/cc-proxy-linux-amd64.tar.gz"
      sha256 "8b711b84ee85f32d10e31ebf0435ec1f3dc8cf3bd401d3059ce68a17c5834dc8"
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
