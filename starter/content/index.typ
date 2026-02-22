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

// ----------------------------------------------------------------------------
// Demo Content
// ----------------------------------------------------------------------------

= Math Demo

Inline math: $e^(i pi) + 1 = 0$

Block math:

$ integral_0^infinity e^(-x^2) d x = sqrt(pi) / 2 $

= Table with Math and Code

#table(
  columns: 2,
  [Code], [Math],
  [`x*x + y*y`], [$x^2 + y^2 = r^2$],
  [`let sum = a + b;`], [$sum_(i=1)^n i = n(n+1)/2$],
)

= Recent Posts

#let posts = (
  pages()
    .filter(p => "/posts/" in p.permalink)
    .filter(p => p.at("draft", default: false) == false)
    .sorted(key: p => p.date)
    .rev()
)

#html.div(class: "space-y-6")[
  #for post in posts.slice(0, calc.min(posts.len(), 5)) {
    ui.post-card(post)
  }
]
