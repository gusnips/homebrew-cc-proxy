class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.1"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.1/cc-proxy-darwin-arm64.tar.gz"
      sha256 "630f636f9a198c467e566ce011dc7cde279f1303166dde7b03fe55ff2a8d0dfb"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.1/cc-proxy-darwin-amd64.tar.gz"
      sha256 "fbfeed2e0308b4ffdffa23fe230421c9db7283d416516f24072d8a18e1af13a9"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.1/cc-proxy-linux-arm64.tar.gz"
      sha256 "f6d7517b369a72a545cd136a6a9a266fdd10dfa72e97a6c7fc99b3dd924be96b"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.1/cc-proxy-linux-amd64.tar.gz"
      sha256 "fc046d5c82d02aeb9c9f1090c9ae3e176c2fbfcf0f67c8932ae34b6ec2f9e377"
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
