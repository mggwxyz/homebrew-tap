# frozen_string_literal: true

# Homebrew formula for Bonsai (Bun build-from-source).
class Bonsai < Formula
  desc "Manage per-branch git worktrees with ports and Caddy URLs"
  homepage "https://github.com/mggwxyz/bonsai"
  url "https://github.com/mggwxyz/bonsai.git", tag: "v0.9.0"
  license "MIT"

  depends_on "bun" => :build
  depends_on "caddy"

  def install
    # The TypeScript sources live under ts/ until it is promoted to the repo
    # root; build the single-file binary from there.
    cd "ts" do
      system "bun", "install", "--frozen-lockfile"
      system "bun", "build", "src/main.ts", "--compile", "--outfile", "bonsai"
      bin.install "bonsai"
    end
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
