# homebrew-qmdmm

Homebrew tap for [QMdmm](https://github.com/QMdmm/QMdmm) — the game server, the
bots and the client.

```
brew tap QMdmm/qmdmm
brew install qmdmm
```

That installs `QMdmm6` (the GUI), `QMdmmServer6` and `QMdmmBot6`.

## Status: source builds, no bottles yet

This tap is new, so there is nothing to pour: an install builds QMdmm from the
source tarball of a released tag.

The formula depends on the three Qt sub-modules QMdmm links against — `qtbase`,
`qtdeclarative` and `qtwebsockets` — rather than on Homebrew's `qt`, which is the
meta formula for all 39 sub-modules. `qttools` is a build dependency, for the
Qt Linguist tools the GUI's translations are built with. The first build
therefore installs Qt's core, QML, WebSockets and tools, not Qt's browser engine
and the rest of the collection.

Bottles, once there are any, are produced and verified by
[QMdmmPackagingCi](https://github.com/QMdmm/QMdmmPackagingCi) — the same harness
that builds and checks the deb, rpm, pac and apk packages — and hosted as
release assets of this repository.

## Apple silicon only

The formula is Apple silicon only, and no Intel bottles will be built. Upstream
stopped publishing Intel bottles across homebrew-core — Qt has had none since
September 2026 — so an Intel install would compile Qt from source first, which
takes hours; and Homebrew is removing the ability to run on Intel altogether in
September 2027. Without bottles, an Intel build is possible but
unsupported.

## Why the programs land in `bin/`

`-DQMDMM_MACOS_APP_BUNDLE=OFF`: the three programs install into `bin/` as
siblings, with Qt provided by Homebrew rather than copied inside them. That is
the shape a bottle can be built from, because a bottle relocates an install
prefix rather than an application bundle.

The self-contained shape — a `QMdmm6.app` with Qt's frameworks, plugins and QML
modules inside it, needing nothing installed — is what the `.dmg` is for.

## License

AGPL-3.0-or-later, as QMdmm itself is.
