class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.2.7"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.7/cc-proxy-darwin-arm64.tar.gz"
      sha256 "e2da301acae2f4474dc44ad8af8857f0bbc1c32dfdad00075b9a0df32a069112"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.7/cc-proxy-darwin-amd64.tar.gz"
      sha256 "c8cdcaf3a4f3d5bf1891fe246b8d8cc49e4b9559733bea018bb3caa374c86d28"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.7/cc-proxy-linux-arm64.tar.gz"
      sha256 "578227ce5917bf038bfd6eede5bda7c642e8a2b4a8bbe102dfc4da44cdd6271a"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.2.7/cc-proxy-linux-amd64.tar.gz"
      sha256 "09fed7aa19ead5ff127d4ccca16456479ded66f2b014ea6a2dc983a973951992"
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
