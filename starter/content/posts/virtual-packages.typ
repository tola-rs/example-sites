#import "/templates/post.typ": post
#import "/components/ui.typ" as ui

#import "@tola/site:0.0.0": info
#import "@tola/pages:0.0.0": all-tags, by-tag, by-tags, pages
#import "@tola/current:0.0.0": current-permalink, filename, headings, parent-permalink, path
#import "@tola/current:0.0.0": at-offset, next, prev, take-next, take-prev
#import "@tola/current:0.0.0": breadcrumbs, children, linked-by, links-to, siblings

#let args = (
  title: "Virtual Package Examples",
  date: "2026-02-28",
  author: "Tola",
  summary: "Code + rendered examples for @tola/site, @tola/pages, and @tola/current",
  tags: ("virtual-packages", "tutorial", "typst"),
  pinned: true,
)

#show: post.with(..args)

#let format-date(value) = {
  if value == none { return "none" }
  if type(value) == datetime { return value.display("[year]-[month]-[day]") }
  str(value)
}

#let pluralize(n, singular: "post", plural: "posts") = {
  if n == 1 { singular } else { plural }
}

#let render-page-list(items, empty: "No matching pages.") = [
  #if items.len() == 0 [
    #emph(empty)
  ] else [
    #for item in items [
      #let d = item.at("date", default: none)
      - #link(item.permalink)[#item.title]#if d != none { [ (#format-date(d))] }
    ]
  ]
]

#let all-pages = pages()
#let posts = (
  all-pages.filter(p => "/posts/" in p.permalink and p.at("date", default: none) != none).sorted(key: p => p.date).rev()
)
#let recent-posts = posts.slice(0, calc.min(posts.len(), 5))
#let pinned-posts = {
  let pinned = all-pages.filter(p => p.at("pinned", default: false))
  let with-date = (pinned.filter(p => p.at("date", default: none) != none).sorted(key: p => p.date).rev())
  let without-date = pinned.filter(p => p.at("date", default: none) == none)
  with-date + without-date
}
#let tutorial-posts = by-tag("tutorial")
#let virtual-tutorial-posts = by-tags("virtual-packages", "tutorial")
#let tag-cloud = all-tags()

#let dated-post-pages = (
  all-pages.filter(p => "/posts/" in p.permalink and p.at("date", default: none) != none).sorted(key: p => p.date)
)
#let prev-post = prev(dated-post-pages)
#let next-post = next(dated-post-pages)
#let two-back = at-offset(dated-post-pages, -2)
#let two-forward = at-offset(dated-post-pages, 2)
#let prev-two = take-prev(dated-post-pages, n: 2)
#let next-two = take-next(dated-post-pages, n: 2)
#let crumbs = breadcrumbs(all-pages, include-root: true)
#let child-pages = children(all-pages)
#let sibling-pages = siblings(all-pages)

#let parsed-from-path = {
  if filename == none {
    (date: none, slug: none)
  } else {
    let file = filename.replace(".typ", "").replace(".md", "")
    let parts = file.split("_")
    if parts.len() >= 4 {
      (date: parts.slice(0, 3).join("-"), slug: parts.slice(3).join("-"))
    } else {
      (date: none, slug: file)
    }
  }
}

Tola injects `sys.inputs` and exposes them through Typst's package mechanism.
You use them with standard `#import` syntax, so site metadata, page indexes, and current-page context are available as regular Typst modules.

This design is extensible and customizable:

- Add arbitrary site-level fields in `tola.toml` (`info.extra`) and read them from `@tola/site`.
- Add page-level metadata in each post `args` and query them through `@tola/pages`.
- Compose your own filters, rankings, and navigation logic directly in Typst code.
- ...More

```typst
#import "@tola/site:0.0.0": info
#import "@tola/pages:0.0.0": pages

#let featured = pages().filter(p => p.at("featured", default: false))
Brand color: #info.extra.at("brand-color", default: "sky")
Featured count: #featured.len()
```

= API Overview

#table(
  columns: 2,
  [Package], [Exports],
  [`@tola/site:0.0.0`], [`info`],
  [`@tola/pages:0.0.0`], [`pages()`, `by-tag(tag)`, `by-tags(..tags)`, `all-tags()`],
  [`@tola/current:0.0.0`],
  [`permalink`, `parent-permalink`, `path`, `filename`, `headings`, `links-to`, `linked-by`, `breadcrumbs`, `children`, `siblings`, `at-offset`, `prev`, `next`, `take-prev`, `take-next`],
)

= Site Metadata API (`@tola/site`)

#ui.showcase-demo(
  title: "Read site metadata from `tola.toml`",
  description: "Same pattern as README: import `info` and read `info.title`, `info.author`, and `info.extra`.",
  code: [
    ```typst
    #import "@tola/site:0.0.0": info

    Site: #info.title
    Author: #info.author
    Language: #info.language
    Custom0: #info.extra.at("custom0", default: "<none>")
    Custom1: #info.extra.at("custom1", default: "<none>")
    ```
  ],
  preview: [
    - Site: #info.title
    - Author: #info.author
    - Language: #info.language
    - Custom0: #info.extra.at("custom0", default: "<none>")
    - Custom1: #info.extra.at("custom1", default: "<none>")
  ],
)

== Common Info Fields

- `info.title` / `info.author` / `info.email`
- `info.description` / `info.url` / `info.language`
- `info.copyright`
- `info.extra` for custom structured fields

= Page Query API (`@tola/pages`)

== Recent Posts Query

#ui.showcase-demo(
  title: "Recent 5 posts",
  description: "README example converted to a reusable list block.",
  code: [
    ```typst
    #import "@tola/pages:0.0.0": pages

    #let posts = (pages()
      .filter(p => "/posts/" in p.permalink)
      .filter(p => p.at("date", default: none) != none)
      .sorted(key: p => p.date)
      .rev())

    #let recent = posts.slice(0, calc.min(5, posts.len()))

    #for post in recent {
      [- #link(post.permalink)[#post.title]]
    }
    ```
  ],
  preview: [
    #render-page-list(recent-posts, empty: "No post with date yet.")
  ],
)

== Pinned Ordering Strategy

#ui.showcase-demo(
  title: "Pinned posts + stable date grouping",
  description: "Avoid mixed-type sort keys by splitting pinned pages into date/non-date groups.",
  code: [
    ```typst
    #import "@tola/pages:0.0.0": pages

    #let pinned = pages().filter(p => p.at("pinned", default: false))
    #let with-date = (pinned
      .filter(p => p.at("date", default: none) != none)
      .sorted(key: p => p.date)
      .rev())
    #let without-date = pinned.filter(p => p.at("date", default: none) == none)

    #let ordered = with-date + without-date
    ```
  ],
  preview: [
    #render-page-list(pinned-posts, empty: "No pinned posts.")
  ],
)

== Tag Query Helpers

#ui.showcase-demo(
  title: "Tag query helpers: `by-tag`, `by-tags`, `all-tags`",
  description: "Covers the helper APIs exported by `@tola/pages:0.0.0`.",
  code: [
    ```typst
    #import "@tola/pages:0.0.0": by-tag, by-tags, all-tags

    #let tutorial = by-tag("tutorial")
    #let virtual-and-tutorial = by-tags("virtual-packages", "tutorial")
    #let tags = all-tags()
    ```
  ],
  preview: [
    - tutorial: #tutorial-posts.len() #pluralize(tutorial-posts.len())
    - virtual-packages + tutorial: #virtual-tutorial-posts.len() #pluralize(virtual-tutorial-posts.len())
    - tags: #tag-cloud.join(", ")
  ],
)

= Current Page API (`@tola/current`)

== Context Fields

#ui.showcase-demo(
  title: "Current page context (`permalink`, `parent-permalink`, `path`, `filename`, `headings`)",
  description: "Use permalink-based context values in templates for breadcrumbs, TOC, and layout decisions.",
  code: [
    ```typst
    #import "@tola/current:0.0.0": current-permalink, parent-permalink, path, filename, headings

    Current permalink: #current-permalink
    Parent permalink: #parent-permalink
    Source path: #path
    Filename: #filename
    Heading count: #headings.len()
    ```
  ],
  preview: [
    - `permalink`: #current-permalink
    - `parent-permalink`: #parent-permalink
    - `path`: #path
    - `filename`: #filename
    - `headings`: #headings.len()
  ],
)

== Filename-Derived Metadata

#ui.showcase-demo(
  title: "Extract date-like prefix from `filename`",
  description: "Pattern from README: works for filenames like `2025_02_25_my-post.typ`.",
  code: [
    ```typst
    #import "@tola/current:0.0.0": path, filename

    #let file = filename.replace(".typ", "")
    #let parts = file.split("_")
    #let auto-date = if parts.len() >= 4 {
      parts.slice(0, 3).join("-")
    } else {
      none
    }
    ```
  ],
  preview: [
    - source path: #if path != none { path } else { "none" }
    - filename: #if filename != none { filename } else { "none" }
    - derived date: #if parsed-from-path.date != none { parsed-from-path.date } else { "<none>" }
    - derived slug: #parsed-from-path.slug
  ],
)

== Hierarchy Navigation

#ui.showcase-demo(
  title: "Prev/next + breadcrumbs + hierarchy helpers",
  description: "Navigation helpers from `@tola/current` for section pages and article pages.",
  code: [
    ```typst
    #import "@tola/pages:0.0.0": pages
    #import "@tola/current:0.0.0": prev, next, breadcrumbs, children, siblings

    #let all = pages()
    #let dated-posts = all
      .filter(p => "/posts/" in p.permalink and p.date != none)
      .sorted(key: p => p.date)

    #let prev-page = prev(dated-posts)
    #let next-page = next(dated-posts)
    #let crumbs = breadcrumbs(all, include-root: true)
    #let direct-children = children(all)
    #let same-level = siblings(all)
    ```
  ],
  preview: [
    - prev: #if prev-post != none { link(prev-post.permalink)[#prev-post.title] } else { "<none>" }
    - next: #if next-post != none { link(next-post.permalink)[#next-post.title] } else { "<none>" }
    - breadcrumbs:
    #for (idx, crumb) in crumbs.enumerate() [
      #if idx > 0 [#" / "]
      #if crumb.exists {
        link(crumb.permalink)[#crumb.title]
      } else {
        crumb.title
      }
    ]
    - stats: children = #child-pages.len(), siblings = #sibling-pages.len(), links-to = #links-to.len(), linked-by = #linked-by.len()
  ],
)

== Offset Navigation Window

#ui.showcase-demo(
  title: "Offset helpers: `at-offset`, `take-prev`, `take-next`",
  description: "Build navigation windows around the current page without manual index math.",
  code: [
    ```typst
    #import "@tola/pages:0.0.0": pages
    #import "@tola/current:0.0.0": at-offset, take-prev, take-next

    #let dated = (pages()
      .filter(p => "/posts/" in p.permalink and p.date != none)
      .sorted(key: p => p.date))

    #let two-back = at-offset(dated, -2)
    #let two-forward = at-offset(dated, 2)
    #let previous = take-prev(dated, n: 2)
    #let next = take-next(dated, n: 2)
    ```
  ],
  preview: [
    - at-offset(-2): #if two-back != none { link(two-back.permalink)[#two-back.title] } else { "<none>" }
    - at-offset(+2): #if two-forward != none { link(two-forward.permalink)[#two-forward.title] } else { "<none>" }
    - take-prev(2) = #prev-two.len(), take-next(2) = #next-two.len()
    #for item in prev-two [
      #let d = item.at("date", default: none)
      - #link(item.permalink)[#item.title]#if d != none { [ (#format-date(d))] }
    ]
    - Current page: #if current-permalink != none { link(current-permalink)[#args.title] } else { args.title }#if args.date != none { [ (#format-date(args.date))] }
    #for item in next-two [
      #let d = item.at("date", default: none)
      - #link(item.permalink)[#item.title]#if d != none { [ (#format-date(d))] }
    ]
  ],
)

= Page Metadata Contract

== Standard Fields

Each entry from `pages()` is page metadata and includes common keys like:

- `permalink`, `title`, `date`, `author`, `summary`
- `tags`, `draft`
- ...

== Custom Fields

Any custom metadata fields you provide:

- `pinned`, `order`
- ...
