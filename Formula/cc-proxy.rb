class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.4.5"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.5/cc-proxy-darwin-arm64.tar.gz"
      sha256 "28b9f3169e821de7249314779760b6990b07110580cdbff8470536426820b5b0"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.5/cc-proxy-darwin-amd64.tar.gz"
      sha256 "1750f7d90d6ebf5e7659db03382f9b5be6aec4c13ee634875158a129795210c1"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.5/cc-proxy-linux-arm64.tar.gz"
      sha256 "9a21e50a3e6929a553c272f8eae13deb7db6df86121c103f506254bb7cafc9fb"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.4.5/cc-proxy-linux-amd64.tar.gz"
      sha256 "ba40c1fcac886b90374acc37bfe4330be4aeceee755b66a2032b1c236ce473dd"
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
