class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.12"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.12/cc-proxy-darwin-arm64.tar.gz"
      sha256 "cd137197b59827e965d8e49ca17e2d4cb998d5bf0365e1d626ea84224e2c5ef1"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.12/cc-proxy-darwin-amd64.tar.gz"
      sha256 "5a45b6c5aa111f722fad0d039a7b763b2b5d6cb074278052fc9802a1c69fb501"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.12/cc-proxy-linux-arm64.tar.gz"
      sha256 "2ee92198edf6042446581a66d7048cb59cfecfa31b1cfecc9fff471e560d490f"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.12/cc-proxy-linux-amd64.tar.gz"
      sha256 "f0f6874fc532108d6611497d0e66e33523260e3b54a45da5dc0b50d8df9ae88f"
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
