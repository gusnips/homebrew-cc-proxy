class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.2"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.2/cc-proxy-darwin-arm64.tar.gz"
      sha256 "4c5a875be8c401de1ffd8b9a8196c979b932117073a2bb56fcab2ed91b7c3bbe"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.2/cc-proxy-darwin-amd64.tar.gz"
      sha256 "7b7da5fe85bcd8b82eb87d7c0fcbb7ac464bced18808c184f9bc2fe41f00e0e8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.2/cc-proxy-linux-arm64.tar.gz"
      sha256 "a4498cb715c45b0ddfb0fe433ca3e8864fd87cb28dd0a9fcf73eedcb352da73b"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.2/cc-proxy-linux-amd64.tar.gz"
      sha256 "bf3fdcd39eba26453c0049f6110d7b9ad04b6a9b12ab5686bb68661a2ccef811"
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
