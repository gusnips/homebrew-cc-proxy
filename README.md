# homebrew-cc-proxy

Homebrew tap for [cc-proxy](https://github.com/gusnips/cc-proxy).

```sh
brew tap gusnips/cc-proxy
brew install cc-proxy
```

Or in one line:

```sh
brew install gusnips/cc-proxy/cc-proxy
```

After tapping once, updates are just `brew upgrade cc-proxy`.

## Maintainer notes

Each release only touches `Formula/cc-proxy.rb`: bump `version`, the four
`url`s, and paste the four `sha256` values from the published GitHub Release
assets (`cc-proxy-<platform>.sha256`).
