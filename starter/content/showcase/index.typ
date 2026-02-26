#import "@tola/pages:0.0.0": pages
#import "@tola/current:0.0.0": children, current-permalink
#import "/templates/page.typ": page
#import "/components/ui.typ" as ui

#show: page.with(
  title: "Showcase",
  summary: "Feature demonstrations and examples for issues, PRs, and feature requests",
  pinned: true,
)

#html.div(class: "text-center mb-8")[
  #html.h1(class: "text-4xl font-bold text-accent")[Showcase]
  #html.p(class: "text-muted")[
    Feature demonstrations and examples for issues, PRs, and feature requests.
  ]
]

= About

This section contains demonstrations of Tola features. \
Each article showcases a specific capability, making it easy to:

- Test new features during development
- Reference implementations for issues and PRs

= Articles

#let showcase-posts = (
  pages().filter(p => "/showcase/" in p.permalink and p.permalink != current-permalink)
)

// Sort by date if available
#let showcase-posts = {
  let with-date = showcase-posts.filter(p => p.at("date", default: none) != none)
  let without-date = showcase-posts.filter(p => p.at("date", default: none) == none)
  with-date.sorted(key: p => p.date).rev() + without-date
}

#html.div(class: "space-y-6")[
  #for post in showcase-posts {
    ui.post-card(post)
  }
]

#if showcase-posts.len() == 0 [
  #html.p(class: "text-muted italic")[No showcase articles yet.]
]
