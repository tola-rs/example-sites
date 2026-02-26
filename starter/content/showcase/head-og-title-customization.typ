#import "/templates/post.typ": post

#let args = (
  title: "Customize Head, OG Tags, and Page Title",
  date: "2026-03-04",
  author: "Tola",
  summary: "How `post.typ` injects head content, Open Graph tags, and browser title.",
  tags: ("showcase", "tutorial", "seo", "head"),
  draft: false,
)

#show: post.with(..args)

= Overview

`post.typ` uses `wrap-page(...)` with a `head` callback. \
The callback receives page metadata (`m`), so head tags can be generated from the current article fields.

Use `head: m => [...]` to return any head elements:

```typst
#let post = wrap-page(
  base: base,
  head: m => [
    // custom head content here
  ],
  view: (body, m) => [...]
)
```

= Inject OG Tags

`post.typ` already injects OG tags via `og-tags(...)`:

```typst
head: m => [
  #og-tags(
    title: m.title,
    description: m.summary,
    type: "article",
    site-name: info.title,
    author: m.author,
    published: m.date,
    tags: m.tags,
  )
]
```

= Change Browser Tab Title

You can override this format, for example:

```typst
#if m.title != none {
  html.title(m.title + " | " + info.title)
} else {
  html.title(info.title)
}
```
