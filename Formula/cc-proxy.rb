class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.3"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.3/cc-proxy-darwin-arm64.tar.gz"
      sha256 "fbc5e464e83ae86c5f0d247b0f1092c9f0e0ef1f6a0ecab272eb8da4804c4610"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.3/cc-proxy-darwin-amd64.tar.gz"
      sha256 "6b65bdce5daa485345fc5511949afc5b894ad3b85ac94f6b709321f2505233d8"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.3/cc-proxy-linux-arm64.tar.gz"
      sha256 "11d9f8a23b1957e014b970a77bee5dcb53fb99171a351b89904758eec89bfc92"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.3/cc-proxy-linux-amd64.tar.gz"
      sha256 "e45a12b998507b412287b479fe886725adee3a42510a0bd0dc4e99ca2fdf09a3"
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
