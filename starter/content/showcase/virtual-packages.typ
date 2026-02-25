#import "/templates/post.typ": post

#let args = (
  title: "Virtual Packages Guide",
  date: "2025-02-25",
  author: "Tola",
  summary: "Complete guide to @tola virtual packages with practical examples",
  tags: ("showcase", "virtual-packages", "tutorial"),
  pinned: true,
)

#show: post.with(..args)

Tola provides virtual packages that inject site-wide data at compile time. This guide covers all available packages with practical examples.

= Available Packages

#table(
  columns: 2,
  [Package], [Purpose],
  [`@tola/site:0.0.0`], [Site configuration from `tola.toml`],
  [`@tola/pages:0.0.0`], [All pages metadata and filtering],
  [`@tola/current:0.0.0`], [Current page context and navigation],
)

= `@tola/site`

Access site metadata from `[site.info]` in `tola.toml`:

```typst
#import "@tola/site:0.0.0": info

Site: #info.title
Author: #info.author
Custom data: #info.extra.custom
```

== Available Fields

- `info.title` — Site title
- `info.author` — Site author
- `info.email` — Contact email
- `info.description` — Site description
- `info.url` — Site URL
- `info.language` — Language code (e.g., "en")
- `info.copyright` — Copyright notice
- `info.extra` — Custom data dictionary

= `@tola/pages`

Query and filter all pages in your site:

```typst
#import "@tola/pages:0.0.0": pages, by-tag, all-tags
```

== Recent Posts

```typst
#let recent = (pages()
  .filter(p => "/posts/" in p.permalink)
  .filter(p => p.at("draft", default: false) == false)
  .filter(p => p.at("date", default: none) != none)
  .sorted(key: p => p.date)
  .rev()
  .slice(0, 5))

#for post in recent {
  [- #link(post.permalink)[#post.title]]
}
```

== Pinned Posts

Use `pinned: true` in page metadata:

```typst
// In your page:
#set page(meta: (pinned: true, title: "Important"))

// Query pinned posts:
#let pinned = pages().filter(p => p.at("pinned", default: false))
```

== Custom Sort Order

```typst
// In pages: #set page(meta: (order: 1))

#let docs = (pages()
  .filter(p => "/docs/" in p.permalink)
  .sorted(key: p => p.at("order", default: 999)))
```

== Tag Filtering

```typst
// Posts with specific tag
#let rust-posts = by-tag("rust")

// Posts with multiple tags
#let advanced = by-tags("rust", "advanced")

// All unique tags
#let tags = all-tags()
```

= `@tola/current`

Access current page context for navigation:

```typst
#import "@tola/current:0.0.0": path, parent, source, headings
#import "@tola/current:0.0.0": prev, next, breadcrumbs, children
```

== Page Info

- `path` — Current page permalink (e.g., "/posts/hello/")
- `parent` — Parent page permalink (e.g., "/posts/")
- `source` — Source file path (e.g., "posts/2025_02_25_hello.typ")
- `headings` — Array of `{level, text}` from document

== Extract Date from Filename

```typst
#import "@tola/current:0.0.0": source

// source = "posts/2025_02_25_hello.typ"
#let parts = source.split("/").last().split("_")
#let date = datetime(
  year: int(parts.at(0)),
  month: int(parts.at(1)),
  day: int(parts.at(2)),
)
```

== Prev/Next Navigation

```typst
#import "@tola/pages:0.0.0": pages
#import "@tola/current:0.0.0": prev, next

#let sorted = pages().filter(p => p.date != none).sorted(key: p => p.date)

#let prev-post = prev(sorted)
#let next-post = next(sorted)

#if prev-post != none { link(prev-post.permalink)[← Previous] }
#if next-post != none { link(next-post.permalink)[Next →] }
```

== Breadcrumbs

```typst
#import "@tola/pages:0.0.0": pages
#import "@tola/current:0.0.0": breadcrumbs

#let crumbs = breadcrumbs(pages(), include-root: true)

#for (i, c) in crumbs.enumerate() {
  if i > 0 [ / ]
  link(c.permalink)[#c.title]
}
// Output: Home / Blog / My Post
```

== Children & Siblings

```typst
#import "@tola/pages:0.0.0": pages
#import "@tola/current:0.0.0": children, siblings

// Direct children of current page
#let child-pages = children(pages())

// Sibling pages (same parent)
#let sibling-pages = siblings(pages())
```

= Page Metadata

Each page object from `pages()` contains:

#table(
  columns: 2,
  [Field], [Description],
  [`permalink`], [URL path (e.g., "/posts/hello/")],
  [`title`], [Page title],
  [`date`], [Publication date (datetime or string)],
  [`author`], [Author name],
  [`summary`], [Short description],
  [`tags`], [Array of tag strings],
  [`draft`], [Draft status (boolean)],
  [`pinned`], [Pinned status (boolean)],
  [`...`], [Any custom metadata from `#set page(meta: (...))`],
)

= Tips

== Avoid Empty Arrays in Filter Phase

During scan phase, `pages()` returns empty array. Handle gracefully:

```typst
#let posts = pages()
#if posts.len() > 0 {
  // Safe to use posts
}
```

== Combine Filters

Chain filters for complex queries:

```typst
#let featured = (pages()
  .filter(p => "/posts/" in p.permalink)
  .filter(p => not p.at("draft", default: false))
  .filter(p => p.at("featured", default: false))
  .sorted(key: p => p.date)
  .rev())
```
