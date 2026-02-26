#import "/templates/post.typ": post
#import "@tola/current:0.0.0": current-permalink

#let oscillation-a = "/showcase/current-permalink-oscillation-a/"
#let oscillation-b = "/showcase/current-permalink-oscillation-b/"

// Feed current-permalink back into post.with(permalink: ...).
// This toggles between two permalinks and should trigger oscillation detection.
#let target-permalink = if current-permalink == oscillation-a {
  oscillation-b
} else {
  oscillation-a
}

#let args = (
  title: "Current Permalink Feedback And Oscillation Detection",
  date: "2026-03-04",
  author: "Tola",
  summary: "Pass @tola/current.current-permalink into post.with(permalink: ...) and observe iterative oscillation handling.",
  tags: ("showcase", "virtual-package", "current", "permalink", "oscillation"),
  draft: true,
)

#show: post.with(..args, permalink: target-permalink)

= Goal

This page intentionally feeds `@tola/current.current-permalink` into `#show: post.with(..., permalink: ...)`.
It is designed to validate iterative metadata stability and oscillation detection behavior.

= Runtime Values

- injected `current-permalink`: #if current-permalink != none { current-permalink } else { "<none>" }
- `permalink` passed to `post.with`: #target-permalink
- toggle rule: `a -> b`, `b -> a`

= Expected Behavior

When building, metadata can alternate between:

1. `/showcase/current-permalink-oscillation-a/`
2. `/showcase/current-permalink-oscillation-b/`

The iterative compiler should detect repeated metadata hash states and stop with an oscillation warning instead of looping forever.
