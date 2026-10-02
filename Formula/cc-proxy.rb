class CcProxy < Formula
  desc "Anthropic-compatible proxy for Claude Code provider backends"
  homepage "https://github.com/gusnips/cc-proxy"
  version "0.1.50"
  license "MIT"

  # sha256 values are taken from the published GitHub Release assets
  # (cc-proxy-<platform>.sha256) every time `version` is bumped.
  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.50/cc-proxy-darwin-arm64.tar.gz"
      sha256 "65a18728a2b6a2a6ed81405e6cef06b450ce7ff622a00d50907e9792bc418428"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.50/cc-proxy-darwin-amd64.tar.gz"
      sha256 "eefe7952e8b33cd6439e0c3653a232e0bfdcf58577e55bce50ad9b531bcb0646"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.50/cc-proxy-linux-arm64.tar.gz"
      sha256 "4821b3999b0ed1ff00bce8ed576f9f6a4bb1752a614c4bea914e8e4a44ced919"
    else
      url "https://github.com/gusnips/cc-proxy/releases/download/v0.1.50/cc-proxy-linux-amd64.tar.gz"
      sha256 "384b4cb5db53c9751f8bff63a0fcb081bd165d6228593aee3c34072fe996fd03"
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
