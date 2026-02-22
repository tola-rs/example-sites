// UI components
// Import: #import "/components/ui.typ" as ui

#import "/utils/tola.typ": cls
#import "/components/layout.typ" as layout

/// Navigation link
#let nav-link(href, label) = html.a(
  class: "text-muted hover:text-accent transition-colors",
  href: href,
)[#label]

/// Tag badge
#let tag(name) = html.span(
  class: "px-2 py-1 text-xs bg-surface rounded text-accent",
)[#name]

/// Card container
#let card(title: none, body) = html.div(class: "p-4 bg-surface rounded-lg")[
  #if title != none { html.h3(class: "font-semibold text-accent mb-2")[#title] }
  #body
]

/// Post card for blog listings
#let post-card(post) = {
  let date = post.at("date", default: "")
  html.a(
    class: "block mb-6 p-4 border border-white/10 rounded-lg bg-surface/50 hover:bg-surface transition-colors no-underline group",
    href: post.permalink,
  )[
    #html.h3(class: "text-xl font-semibold mb-2 group-hover:text-accent transition-colors")[
      #post.title
    ]

    #layout.flex-row(
      gap: 4,
      html.span(class: "text-sm text-muted")[#date],
      ..post.at("tags", default: ()).map(t => tag(t)),
    )

    #if post.at("summary", default: none) != none {
      html.p(class: "mt-2 text-muted")[#post.at("summary")]
    }
  ]
}
