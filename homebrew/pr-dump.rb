# Formula for pr-dump
class PrDump < Formula
  desc "Dump GitHub PR context (metadata, comments, diffs) for LLM review"
  homepage "https://github.com/CheerChen/pr-dump"
  url "https://github.com/CheerChen/pr-dump/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256_AFTER_RELEASE"
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