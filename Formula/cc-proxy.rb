class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.4"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.4/cc-proxy-darwin-arm64.tar.gz"
      sha256 "d7aec8e671157aa9f3fc910e7243c745a7b3e2ef94f46b36d6ba05785d2d4822"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.4/cc-proxy-darwin-amd64.tar.gz"
      sha256 "41f1472d32f33be4bfba5d75f238eb1d3cd2cbd9cd4be8243f6d45a0bd3c458e"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.4/cc-proxy-linux-arm64.tar.gz"
      sha256 "2888a081f7637ec8f4f6569b1a1ec32be4e2e2a97d1063abf331509d98c7ab44"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.4/cc-proxy-linux-amd64.tar.gz"
      sha256 "40c3db96c3c863200225743b49dfea91ac28c1f28f7ea441952b606f704a70eb"
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
