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
      sha256 "e22e1cad0e7a8b2182d4cc4e703c6faa0f049be39dbd868cced31146266755b4"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.15/cc-proxy-darwin-amd64.tar.gz"
      sha256 "5a25d67b638aafd0960996926797243cc021d6fe61347fcb9a7bec7e62b1de0d"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.15/cc-proxy-linux-arm64.tar.gz"
      sha256 "d9f7f721d4f906dbc3de2340b7fca28935a0173d8b55da7f92ab70e7e78a804d"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.15/cc-proxy-linux-amd64.tar.gz"
      sha256 "a75d0bef706fd236dc4311371a406e0c0a651bfd0712c784af5ae3b8e9feea43"
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
