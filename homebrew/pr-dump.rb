# Formula for pr-dump
class PrDump < Formula
  desc "Dump GitHub PR context (metadata, comments, diffs) for LLM review"
  homepage "https://github.com/CheerChen/pr-dump"
  url "https://github.com/CheerChen/pr-dump/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0562fda92aff51219c373f2aff2ae0c0c27387c1b54b4934baa39d287b177883"
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