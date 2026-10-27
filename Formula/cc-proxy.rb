class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.9"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.9/cc-proxy-darwin-arm64.tar.gz"
      sha256 "3b6f4604f3a00201d78e39d1d4c9e54b87f4c8b42e38748035ea5d3664879cad"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.9/cc-proxy-darwin-amd64.tar.gz"
      sha256 "94be3793d9d67d0ea36df78c75e00a097839fde2c6657695f6d7f72301935b85"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.9/cc-proxy-linux-arm64.tar.gz"
      sha256 "3d452006d86b9f814697dbb030c1339205c58c87b8d2306f1eebf194676e7414"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.9/cc-proxy-linux-amd64.tar.gz"
      sha256 "bf44a1fe714ac353819f1a3584bfecad228c2aee48f327c878509ef2a58fbefa"
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
