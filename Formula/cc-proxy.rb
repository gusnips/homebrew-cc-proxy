class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.13"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.13/cc-proxy-darwin-arm64.tar.gz"
      sha256 "4df87d7ddd4d37ea5006e8f1c22a7f30cba5915ecedf7112269564abe3102f4a"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.13/cc-proxy-darwin-amd64.tar.gz"
      sha256 "73d617e18f1a0355ed4b578c6fb97d54896223f2a87cec9ce1b9ed3cb6d960bf"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.13/cc-proxy-linux-arm64.tar.gz"
      sha256 "3e996fa51074862465863dc03bd4d34ab2968e419ca21cee3e1354c324d8b908"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.13/cc-proxy-linux-amd64.tar.gz"
      sha256 "af740006e781a559a2ff78fc45a95c754870c02bb29f988c38cd7a2a595edfce"
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
