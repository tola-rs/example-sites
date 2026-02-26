#import "@tola/pages:0.0.0": pages
#import "/templates/page.typ": page
#import "/components/ui.typ" as ui

#show: page.with(title: "Home")

// Title
#html.div(class: "text-center mb-8")[
  #html.h1(class: "text-4xl font-bold text-accent")[Welcome to My Blog]
  #html.p(class: "text-muted")[
    Built with #link("https://typst.app")[Typst] and #link("https://github.com/tola-ssg/tola-ssg")[Tola].
  ]
]

= Getting Started

- Edit this file at `content/index.typ`
- Add new posts in `content/posts/`
- Customize styles in `assets/styles/tailwind.css`
- Run `tola serve` for live preview

= Features

+ *Fast Rebuilds* — Only changed files are recompiled
+ *Tailwind CSS* — Utility-first styling out of the box
+ *Math Support* — Beautiful equations with Typst

= Pinned

#let pinned-posts = (
  pages().filter(p => p.at("pinned", default: false) == true)
)

// Sort pinned posts by date in ascending order; undated posts stay at the end
#let pinned-posts = {
  let with-date = pinned-posts.filter(p => p.at("date", default: none) != none)
  let without-date = pinned-posts.filter(p => p.at("date", default: none) == none)
  with-date.sorted(key: p => p.date) + without-date
}

#html.div(class: "space-y-6")[
  #for post in pinned-posts.slice(0, calc.min(pinned-posts.len(), 10)) {
    ui.post-card(post)
  }
]

#if pinned-posts.len() == 0 [
  #html.p(class: "text-muted italic")[No pinned posts yet.]
]
