class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.47"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.47/cc-proxy-darwin-arm64.tar.gz"
      sha256 "1b35f46a3194f9eae0c6cfbed9473caa80dfe97044b65304bfdcb813664f1ae5"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.47/cc-proxy-darwin-amd64.tar.gz"
      sha256 "c2babbe48925eb75e551000ea178d5ba5be5b781f8597c66b2a93fba309d4a05"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.47/cc-proxy-linux-arm64.tar.gz"
      sha256 "dd4be6832b60ca0bbfdeeacc65b3cdca969e3265c615ddba97c989d2f000f61c"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.47/cc-proxy-linux-amd64.tar.gz"
      sha256 "e7b35c19ded3b6354761be6ed9b17d5bfbb0e156973c003d15e9c57ea232b520"
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
