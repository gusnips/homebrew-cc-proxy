class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.16"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.16/cc-proxy-darwin-arm64.tar.gz"
      sha256 "a6bc5f6c697342d760190cc896369dde11370014588c3fd5d88185e6b588d672"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.16/cc-proxy-darwin-amd64.tar.gz"
      sha256 "6ece7a47363fccbc6dd989be431fd392119433dbe0c8e27ed99a5bf40737219c"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.16/cc-proxy-linux-arm64.tar.gz"
      sha256 "d0ce699cf699db8d7fb6cbb34a6e934146b49b3560dab56b6ed66112fd647822"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.16/cc-proxy-linux-amd64.tar.gz"
      sha256 "787e86e0c49729835290d96292843eb5cc04a39b98126702337299036a71d1db"
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
