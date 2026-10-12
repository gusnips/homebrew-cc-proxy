class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.56"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.56/cc-proxy-darwin-arm64.tar.gz"
      sha256 "63fc98a3c719bb4128667fb03e06b6c9b41c0cc3a48f3fc55634770c7dc4bc0b"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.56/cc-proxy-darwin-amd64.tar.gz"
      sha256 "7ea742455ac5b415441e7f8dcc4e61704c0c2b3119425be9e5c0885271040275"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.56/cc-proxy-linux-arm64.tar.gz"
      sha256 "dd82d94433fa825effa4ca8268d4d16b1804cd4aaa248f003dce46ff7ba37a68"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.56/cc-proxy-linux-amd64.tar.gz"
      sha256 "fdbcdca8a9fa90e46e0005932fbcb2fa9071514560442b0c2f86144af5a17dc8"
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
