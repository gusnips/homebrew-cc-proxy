class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.6"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.6/cc-proxy-darwin-arm64.tar.gz"
      sha256 "c6c59a4f9d061c677be300eae4e46f11ef85c7dbd84e3572033f944714e2c413"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.6/cc-proxy-darwin-amd64.tar.gz"
      sha256 "cb506be80d38cf1263c639f89f4fb5aa2892b90574d53494a6973db1893eb47f"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.6/cc-proxy-linux-arm64.tar.gz"
      sha256 "4c06a04412c59c09f1ccc39723d2a62b507f380a880359862bf52308064c3a55"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.6/cc-proxy-linux-amd64.tar.gz"
      sha256 "9069675bf436463efa90ff0c881dbe190750f4d85e8e7a626633478cdd136ce0"
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
