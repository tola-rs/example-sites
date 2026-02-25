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

#let posts = (
  pages()
    .filter(p => "/posts/" in p.permalink)
    .filter(p => p.at("draft", default: false) == false)
    .filter(p => p.at("pinned", default: false) == true)
    .sorted(key: p => p.date)
    .rev()
)

#html.div(class: "space-y-6")[
  #for post in posts.slice(0, calc.min(posts.len(), 5)) {
    ui.post-card(post)
  }
]
