class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.1"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.1/cc-proxy-darwin-arm64.tar.gz"
      sha256 "11bce25aefb6bf389ef16821cbc5c3ddf59255b0467e3655426009c1f90940e0"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.1/cc-proxy-darwin-amd64.tar.gz"
      sha256 "ca1d48939aa7631a57ef3787363435724376274d429d87113412f3f767f78d80"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.1/cc-proxy-linux-arm64.tar.gz"
      sha256 "e5f59bd690278de0a1027709fc35e478d3b7e8126edfc4fe638b394cfcd0f240"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.1/cc-proxy-linux-amd64.tar.gz"
      sha256 "c678e0a264d55ae26ab4ae932c78f62b77d9b67b4320bd4ea96d09278a4797e3"
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
