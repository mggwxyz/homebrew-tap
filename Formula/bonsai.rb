# frozen_string_literal: true

# Homebrew formula for Bonsai (Bun build-from-source).
class Bonsai < Formula
  desc "Manage per-branch git worktrees with ports and Caddy URLs"
  homepage "https://github.com/mggwxyz/bonsai"
  url "https://github.com/mggwxyz/bonsai.git", tag: "v0.9.1"
  license "MIT"

  depends_on "bun" => :build
  depends_on "caddy"

  def install
    system "bun", "install", "--frozen-lockfile"
    system "bun", "--filter", "@bonsai/core", "build"
    system "bun", "build", "apps/bonsai/src/main.ts", "--compile", "--outfile", "bonsai"
    bin.install "bonsai"
  end

  def caveats
    <<~EOS
      To enable `bonsai checkout <worktree>` in zsh, add this to ~/.zshrc:

        eval "$(bonsai shell-init zsh)"

      Or run:

        bonsai install-shell zsh
    EOS
  end

  test do
    system bin/"bonsai", "--version"
  end
end
