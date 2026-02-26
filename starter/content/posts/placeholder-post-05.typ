#import "/templates/post.typ": post

#let args = (
  title: "Placeholder Post 05",
  date: "2026-03-03",
  author: "Tola",
  summary: "Placeholder content used to populate /posts for demos.",
  tags: ("placeholder", "demo-data"),
)

#show: post.with(..args)

= Placeholder Notice

This post exists only as filler content for starter-site examples.
