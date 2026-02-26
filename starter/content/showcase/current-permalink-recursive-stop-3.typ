#import "/templates/post.typ": post
#import "@tola/current:0.0.0": current-permalink

// Two rewrite steps, then fixed point:
// current -> phase-1 -> phase-2 -> phase-2
#let target-permalink = if current-permalink == none {
  none
} else if current-permalink.ends-with("current-permalink-recursive-stop-3-phase-2/") {
  current-permalink
} else if current-permalink.ends-with("current-permalink-recursive-stop-3-phase-1/") {
  current-permalink.replace(
    "current-permalink-recursive-stop-3-phase-1/",
    "current-permalink-recursive-stop-3-phase-2/",
  )
} else {
  current-permalink.replace(
    "current-permalink-recursive-stop-3/",
    "current-permalink-recursive-stop-3-phase-1/",
  )
}

#let args = (
  title: "Bounded Recursion From `current-permalink` (Stop In 3)",
  date: "2026-03-04",
  author: "Tola",
  summary: "A two-step permalink transition that converges at phase-2.",
  tags: ("showcase", "virtual-package", "current", "permalink", "recursion"),
  draft: true,
)

#show: post.with(..args, permalink: target-permalink)

= Rule

`source -> phase-1 -> phase-2 -> phase-2`.

= Runtime Values

- injected `current-permalink`: #if current-permalink != none { current-permalink } else { "<none>" }
- computed target permalink: #target-permalink
- phase-1 suffix: `current-permalink-recursive-stop-3-phase-1/`
- phase-2 suffix (stable): `current-permalink-recursive-stop-3-phase-2/`

= Expected Convergence

1. Pass 1: rewrite to `phase-1`.
2. Pass 2: rewrite to `phase-2`.
3. Pass 3: `phase-2` stays `phase-2`, convergence reached.
