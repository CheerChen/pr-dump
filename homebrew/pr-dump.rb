# Formula for pr-dump
class PrDump < Formula
  desc "Dump GitHub PR context (metadata, comments, diffs) for LLM review"
  homepage "https://github.com/CheerChen/pr-dump"
  url "https://github.com/CheerChen/pr-dump/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "e3062ef5c531ea6b90daa85f1e6dd1413ea2931cb9daa4d89cd64378c379b91b"
  license "MIT"

  depends_on "gh"
  depends_on "jq"

  def install
    bin.install "pr-dump.sh" => "pr-dump"
  end

  test do
    assert_match "pr-dump version", shell_output("#{bin}/pr-dump --version")
  end
end