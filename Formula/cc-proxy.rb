class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.8"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.8/cc-proxy-darwin-arm64.tar.gz"
      sha256 "d169c507a7e7c6eede6a655778261d39b1ba3077f28a585ce323d29207db9424"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.8/cc-proxy-darwin-amd64.tar.gz"
      sha256 "9468ac0f22aac7f9ce6e8e595d9ea85ad6573cc66b3f12de34fbffdc4c4509c0"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.8/cc-proxy-linux-arm64.tar.gz"
      sha256 "1e807acbc34db4508ae32869a80acc52289df664ee0af459c3de566c9cc3a1ca"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.8/cc-proxy-linux-amd64.tar.gz"
      sha256 "292add1e117244c71c4df997adb1db9c2c3c9b65661dea09254a7f08bb646526"
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
