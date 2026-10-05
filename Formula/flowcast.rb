# frozen_string_literal: true

# Homebrew formula for flowcast (Node build-from-source).
# Edit this in the flowcast repository: the release workflow copies it to the tap.
# `tag:` must name a pushed origin tag, so the copy happens only after that tag exists.
class Flowcast < Formula
  desc "Record, test, and demonstrate web app interactions with Playwright"
  homepage "https://github.com/mggwxyz/flowcast"
  url "https://github.com/mggwxyz/flowcast.git", tag: "v0.2.0" # x-release-please-version
  license "MIT"

  depends_on "pnpm" => :build
  depends_on "ffmpeg"
  depends_on "node"

  def install
    # No dependency needs its install script, and pnpm fails on unapproved ones.
    system "pnpm", "install", "--frozen-lockfile", "--ignore-scripts"
    system "npm", "run", "build"
    # Leave only the runtime dependencies, at the versions the lockfile pins.
    system "pnpm", "prune", "--prod", "--ignore-scripts"
    libexec.install "dist", "node_modules", "package.json"

    (bin/"flowcast").write <<~SH
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dist/cli/index.js" "$@"
    SH
  end

  def caveats
    <<~EOS
      flowcast needs Playwright's Chromium, downloaded once per user:

        flowcast install-browser
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowcast --version")
  end
end
