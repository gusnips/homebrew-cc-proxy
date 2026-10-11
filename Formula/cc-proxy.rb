class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.54"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.54/cc-proxy-darwin-arm64.tar.gz"
      sha256 "dbd9b101094e6f2095510321bbc149f46ba8be2ee992bf9281d262d3cb920750"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.54/cc-proxy-darwin-amd64.tar.gz"
      sha256 "4a2c2fcc8be9876f855c64f5defb8bc8ae0ede131045cac15eb3a18a8c8ef961"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.54/cc-proxy-linux-arm64.tar.gz"
      sha256 "91d8501fcaecab92e79ddc795e26c900f09f894fc87a7babec6cda6fff317606"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.54/cc-proxy-linux-amd64.tar.gz"
      sha256 "88b4339096f05650b76b6cdc8a0a53d2782fe72ed73aed8e00e06f78192343a9"
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
