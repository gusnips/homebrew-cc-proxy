class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.51"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.51/cc-proxy-darwin-arm64.tar.gz"
      sha256 "0276d7cbfaf922aac0a9215f7ca91cfc70709c855f3683e209b1a65e414a89b8"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.51/cc-proxy-darwin-amd64.tar.gz"
      sha256 "b924b5d34563e5510568e98a773af15883caa6474fc8650802ffc025a0b366d5"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.51/cc-proxy-linux-arm64.tar.gz"
      sha256 "ac7ba7c200a5b177c434bd047a34c09938d4ad0be08092508ffdfd8cf700bb1e"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.51/cc-proxy-linux-amd64.tar.gz"
      sha256 "3fff161275d5558c8bc51aac538007c1159f30f0da5a2911e435dc5d089a68ad"
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
