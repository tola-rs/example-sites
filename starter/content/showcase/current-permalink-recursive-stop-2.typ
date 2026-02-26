#import "/templates/post.typ": post
#import "@tola/current:0.0.0": current-permalink

// One rewrite step, then fixed point:
// current -> current(replaced as *-final) -> stable
#let target-permalink = if current-permalink == none {
  none
} else if current-permalink.ends-with("current-permalink-recursive-stop-2-final/") {
  current-permalink
} else {
  current-permalink.replace(
    "current-permalink-recursive-stop-2/",
    "current-permalink-recursive-stop-2-final/",
  )
}

#let args = (
  title: "Bounded Recursion From `current-permalink` (Stop In 2)",
  date: "2026-03-04",
  author: "Tola",
  summary: "A computed permalink chain that converges after one rewrite step.",
  tags: ("showcase", "virtual-package", "current", "permalink", "recursion"),
  draft: true,
)

#show: post.with(..args, permalink: target-permalink)

= Rule

`target = stable`.

= Runtime Values

- injected `current-permalink`: #if current-permalink != none { current-permalink } else { "<none>" }
- computed target permalink: #target-permalink

= Expected Convergence

1. Pass 1: source permalink is rewritten to `*-final/`.
2. Pass 2: `*-final/` maps to itself, so it converges.
