// Template for posts with date prefix in filename
// Demonstrates @tola/current path + filename fields for Issue #40

#import "/templates/tola.typ": wrap-page
#import "/templates/base.typ": base, colors
#import "/components/layout.typ" as layout
#import "/utils/tola.typ": cls, og-tags
#import "@tola/site:0.0.0": info
#import "@tola/current:0.0.0": filename, headings, path, current-permalink

/// Parse date from filename with format: YYYY_MM_DD_slug.typ
/// Returns: (date: datetime or none, slug: str)
#let parse-filename-meta(filename) = {
  if filename == none { return (date: none, slug: none) }

  let name = filename.replace(".typ", "").replace(".md", "")
  let parts = name.split("_")

  // Check if starts with date pattern (YYYY_MM_DD)
  if parts.len() >= 4 {
    let date = datetime(
      year: int(parts.at(0)),
      month: int(parts.at(1)),
      day: int(parts.at(2)),
    )
    let slug = parts.slice(3).join("-")
    return (date: date, slug: slug)
  }

  // No date prefix found
  (date: none, slug: name)
}

/// Generate permalink from path
/// posts/2025_02_25_hello.typ -> /posts/hello/
#let derive-permalink(path, slug) = {
  if path == none or slug == none { return none }
  let dir = path.split("/").slice(0, -1).join("/")
  if dir == "" { "/" + slug + "/" } else { "/" + dir + "/" + slug + "/" }
}

#let meta-from-filename-post = wrap-page(
  base: base,

  transform-meta: m => {
    let parsed = parse-filename-meta(filename)
    // Set date from filename if not explicitly provided
    if "date" not in m and parsed.date != none {
      m.insert("date", parsed.date)
    }
    // Set permalink from filename if not explicitly provided
    if "permalink" not in m and parsed.slug != none {
      m.insert("permalink", derive-permalink(path, parsed.slug))
    }
    m
  },

  head: m => [
    #og-tags(
      title: m.title,
      description: m.summary,
      type: "article",
      site-name: info.title,
      author: m.author,
      published: m.at("date", default: none),
      tags: m.tags,
    )
    #if m.title != none {
      html.title(m.title + " | " + info.title)
    } else {
      html.title(info.title)
    }
  ],

  view: (body, m) => {
    let parsed = parse-filename-meta(filename)

    // Show rules
    show heading.where(level: 1): it => {
      let id = lower(repr(it.body).replace("\"", "").replace(" ", "-"))
      html.h2(class: cls("text-2xl font-bold mt-8 mb-4", colors.accent), id: id)[
        #html.a(class: "hover:underline underline-offset-4", href: "#" + id)[#it.body]
      ]
    }

    // Debug info showing path/filename parsing
    let debug-view = html.div(class: "my-4 p-4 bg-surface/50 rounded text-sm font-mono")[
      #html.div()[path: #path]
      #html.div()[filename: #filename]
      #html.div()[permalink: #current-permalink]
      #html.div()[parsed.date: #if parsed.date != none { parsed.date.display("[year]-[month]-[day]") } else { "none" }]
      #html.div()[parsed.slug: #parsed.slug]
      #html.div()[m.date: #if m.at("date", default: none) != none { m.date.display("[year]-[month]-[day]") } else { "none" }]
      #html.div()[m.permalink: #m.at("permalink", default: "none")]
    ]

    // Title
    let title-view = if m.title != none {
      html.h1(class: "text-3xl sm:text-4xl font-bold text-center my-6")[#m.title]
    }

    // Subtitle with date
    let subtitle-view = if m.at("date", default: none) != none or m.author != none {
      let parts = ()
      if m.at("date", default: none) != none { parts.push(m.date.display("[year]-[month]-[day]")) }
      if m.author != none { parts.push("by " + m.author) }
      html.div(class: cls("text-center", colors.muted))[#parts.join(" · ")]
    }

    html.article(class: "space-y-4")[
      #title-view #subtitle-view #debug-view #layout.hr #body
    ]
  },
)
