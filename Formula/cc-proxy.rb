class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.5"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.5/cc-proxy-darwin-arm64.tar.gz"
      sha256 "8626d7cae2b559bfd55fa4f7d8023e1966e3e4968a5bed50f77fd6beb0cff13f"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.5/cc-proxy-darwin-amd64.tar.gz"
      sha256 "e81fa9b4beca3175104162b61adc5a6b6211a6aa159ebb40aa815a9b1f224115"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.5/cc-proxy-linux-arm64.tar.gz"
      sha256 "ca9f8c029d26e994c074611856ba59dbaf3475dfbb4d0c0d4c5310dda45da801"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.5/cc-proxy-linux-amd64.tar.gz"
      sha256 "d2188d5cb94d561886c3b9e94b72439f61a37d0775fde3c2e6261a364bbfcbd8"
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
