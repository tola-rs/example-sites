#import "/templates/post.typ": post
#import "@tola/current:0.0.0": current-permalink

#let args = (
  title: "Set `permalink: current-permalink`",
  date: "2026-03-04",
  author: "Tola",
  summary: "Directly assign current-permalink back to post.with(permalink: ...).",
  tags: ("showcase", "virtual-package", "current", "permalink", "fixed-point"),
  draft: true,
)

// Direct self-reference: permalink stays exactly what injector provides.
#show: post.with(..args, permalink: current-permalink)

= What Happens

When `permalink` is set to `current-permalink` directly, metadata reaches a fixed point immediately.

- injected `current-permalink`: #if current-permalink != none { current-permalink } else { "<none>" }
- `permalink` passed to `post.with`: #if current-permalink != none { current-permalink } else { "<none>" }

This is a stable self-reference, so no oscillation is expected.
