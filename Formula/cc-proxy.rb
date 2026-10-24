class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.15"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.15/cc-proxy-darwin-arm64.tar.gz"
      sha256 "e59c0faf8ebc6d0c5ecc1c0b1c503476b7e81ce81ad471cc094ef8ae1d335c56"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.15/cc-proxy-darwin-amd64.tar.gz"
      sha256 "2f0fab85a21635f93634eaef6ba248ea3136fb1eb921dc6c4edf2a3df8112252"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.15/cc-proxy-linux-arm64.tar.gz"
      sha256 "34ca6069cd75d1dac393beb7d97430d97d0eb11851747da61d7231a16a21f218"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.15/cc-proxy-linux-amd64.tar.gz"
      sha256 "3316de1a85cd64885d033a741c5909fe4cbfc7799ad2f813b187559c63a0d8fc"
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
