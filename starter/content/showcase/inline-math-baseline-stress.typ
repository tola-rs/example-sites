#import "/templates/post.typ": post

#let args = (
  title: "Inline Math Baseline Stress Test",
  date: "2026-02-26",
  author: "Tola",
  summary: "Compact stress cases for inline SVG math baseline alignment.",
  tags: ("showcase", "math", "baseline", "typst"),
  draft: false,
)

#show: post.with(..args)

This page checks inline math baseline behavior in realistic text flow.
It focuses on three cases: mixed formula heights, wrap boundaries, and dense inline sequences.

= Mixed Heights In One Line

Short + tall inline formulas in one sentence:
$A := {x in RR | product_(i=1)^oo x " is natural"}$,
$pi((1)/(2))$,
$pi((1)/(1 + (1)/(2)))$,
$pi((1)/(1 + (1)/(1 + (1)/(2))))$.

= Wrap Boundary Cases

This sentence places a tall fraction near the line end so it wraps on narrower
screens: $pi((1)/(1 + (1)/(1 + (1)/(1 + (1)/(1 + (1)/(2))))))$ and then
continues with normal text to verify baseline recovery after wrapping.

Another mixed run for comparison: inline short $(1)/(2)$, medium
$(1)/(1 + (1)/(2))$, tall $(1)/(1 + (1)/(1 + (1)/(2)))$, and very tall
$(1)/(1 + (1)/(1 + (1)/(1 + (1)/(2))))$.

= Dense Inline Sequence

Sequence with increasing height:
$pi((1)/(2))$,
$pi((1)/(1 + (1)/(2)))$,
$pi((1)/(1 + (1)/(1 + (1)/(2))))$,
$pi((1)/(1 + (1)/(1 + (1)/(1 + (1)/(2)))))$,
$pi((1)/(1 + (1)/(1 + (1)/(1 + (1)/(1 + (1)/(2))))))$.
