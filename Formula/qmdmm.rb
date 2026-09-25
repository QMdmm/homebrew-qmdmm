# QMdmm's Homebrew formula. This is the one authoritative copy: the packaging
# harness (QMdmmPackagingCi) taps this repository rather than carrying a second
# copy, so what a user installs and what the harness verifies is the same
# recipe.
#
# There is no bottle block here. `brew bottle --merge --write` adds one, and
# the harness adds it to its own working copy inside the tap directory - never
# to this file, because a bottle records one exact build on one exact macOS
# version and this repository should only learn about one when a release is
# cut. A user installing today therefore builds from source, which is what the
# urls below describe.
#
# When the harness packages a ref that is not a tag - which is what the daily
# run does, since it packages `main` - it rewrites `url`, `sha256` and
# `version` in that working copy. A branch or a commit has no tag tarball, so
# the url becomes .../archive/<full-sha>.tar.gz and the version, normally
# detected from the url, has to be read out of the source tree and stated
# instead. The values committed here pin the tag that was verified locally: tag
# 0.0.1, whose tarball hashes to the sha256 below (measured three times, once
# through codeload directly).
#
# `QMDMM_MACOS_APP_BUNDLE=OFF` is the switch that makes this the shape a bottle
# can be built from. Left at its default on APPLE, the install produces a
# self-contained `QMdmm6.app` with Qt's frameworks, plugins and QML modules
# copied inside it - that is the `.dmg`'s shape, and it cannot be bottled
# because a bottle relocates a prefix rather than an application bundle.
# Turned off, the three programs land in `bin/` as siblings with Qt provided by
# the machine. Measured locally: OFF against Homebrew's Qt gives all three
# programs an LC_RPATH pointing into `/opt/homebrew/opt/qt/lib` plus the install
# prefix's own `lib`, and all three start.
#
# `depends_on "qt"` is Homebrew's Qt meta formula (83 formulae, including
# qtbase, qtdeclarative and qtwebsockets, which is what QMdmm links against).
# It is the only Qt Homebrew offers, so the Qt 6.7 floor the project declares
# cannot be expressed here: the bottle floats with whatever the tap's `qt`
# currently is.
class Qmdmm < Formula
  desc "Multiplayer card game server, bots and client"
  homepage "https://github.com/QMdmm/QMdmm"
  url "https://github.com/QMdmm/QMdmm/archive/refs/tags/0.0.1.tar.gz"
  sha256 "2fe4085ca4ccd179f04321bfa4317a47f81cd6eb470d3a791db06b5b9f5a60d5"
  license "AGPL-3.0-or-later"
  head "https://github.com/QMdmm/QMdmm.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
           "-G", "Ninja",
           "-DQMDMM_MACOS_APP_BUNDLE=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # The server's `--help` is the cheapest program the package ships that cannot
  # be started by accident: it prints its help text and calls std::exit(0)
  # before it reads any configuration or binds a socket (QMdmmServer/src/
  # config.cpp: `if (parser.isSet("h")) { std::cout << helpText(); std::exit(0); }`).
  # The GUI and the Bot would have to be started and then killed, which is what
  # the harness stages do anyway.
  test do
    system bin/"QMdmmServer6", "--help"
  end
end
