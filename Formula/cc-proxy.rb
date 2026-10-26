class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.6"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.6/cc-proxy-darwin-arm64.tar.gz"
      sha256 "300bf21ad945729a25b051c05a7d6743650e842576a4facd4abd8d3cbcba6cef"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.6/cc-proxy-darwin-amd64.tar.gz"
      sha256 "94a348213de5c801107d10534d84aedb550175b39af39eadcc7a8a9850128da7"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.6/cc-proxy-linux-arm64.tar.gz"
      sha256 "f48376509d558475a4a4d8342cea8c8d0d14a8f50dbdbd834c64d15936e88e97"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.6/cc-proxy-linux-amd64.tar.gz"
      sha256 "854ae0294c7d01f4626bbaaf0de2e4450ac109b2b07c64112697fba389fca132"
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
