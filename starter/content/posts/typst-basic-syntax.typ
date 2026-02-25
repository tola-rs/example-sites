#import "/templates/post.typ": post
#import "/utils/html.typ": img

#let args = (
  title: "Typst Basic Syntax",
  date: "2026-02-24",
  author: "Tola",
  summary: [Typst syntax guide and how it renders to HTML],
  tags: ("typst", "html", "tutorial"),
  pinned: true,
)

#show: post.with(..args)

Typst's native markup automatically converts to semantic HTML. \
Here's how each element renders:

= Getting Started

== Template Structure

Every post starts with a template import and metadata definition:

```typst
#import "/templates/post.typ": post

#let args = (
  title: "Typst Basic Syntax",
  date: "2026-02-24",
  author: "Tola",
  summary: [Typst syntax guide and how it renders to HTML],
  tags: ("typst", "html", "tutorial"),
)

#show: post.with(..args)
```

== Reusing Metadata

Defining metadata in a variable allows you to *reuse* it inside the content. For example:

```typst
_Last updated: #(args.date)_
```

Renders as: _Last updated: #(args.date)_

== Template Features

The `post` template automatically generates:

- *Title & Subtitle*: Displays title, date, and author at the top
- *Tags*: Shown as styled badges (like the tags above)
- *Summary*: Italic text below the title
- *Table of Contents*: Auto-generated from headings (see the TOC above!)

= Text Elements

== Headings

```typst
= Level 1 Heading
== Level 2 Heading
=== Level 3 Heading
```

Renders to `<h2>`, `<h3>`, `<h4>` etc. (h1 is reserved for page title).

== Text Formatting

```typst
*bold text*
_italic text_
`inline code`
```

- *bold text* → `<strong>`
- _italic text_ → `<em>`
- `inline code` → `<code>`

== Links

```typst
#link("https://typst.app")[Typst]
```

Renders to: #link("https://typst.app")[Typst] → `<a href="...">`.

= Structured Content

== Lists

Unordered list with `-`:

```typst
- First item
- Second item
- Third item
```

- First item
- Second item
- Third item

Ordered list with `+`:

```typst
+ Step one
+ Step two
+ Step three
```

+ Step one
+ Step two
+ Step three

== Tables

```typst
#table(
  columns: 2,
  [Code], [Math],
  [`x*x + y*y`], [$x^2 + y^2 = r^2$],
  [`let sum = a + b;`], [$sum_(i=1)^n i = n(n+1)/2$],
)
```

#table(
  columns: 2,
  [Code], [Math],
  [`x*x + y*y`], [$x^2 + y^2 = r^2$],
  [`let sum = a + b;`], [$sum_(i=1)^n i = n(n+1)/2$],
)

== Blockquotes

```typst
#quote[
  The best way to predict the future is to invent it.
]
```

#quote[
  The best way to predict the future is to invent it.
]

= Rich Content

== Code Blocks

````typst
```js
console.log("Hello");
```
````

```js
console.log("Hello");
```

== Math

```typst
Inline: $e^(i pi) + 1 = 0$

Block:
$ integral_0^infinity e^(-x^2) d x = sqrt(pi) / 2 $
```

Inline: $e^(i pi) + 1 = 0$

Block:
$ integral_0^infinity e^(-x^2) d x = sqrt(pi) / 2 $

Math is rendered as SVG wrapped in semantic elements.

== Images

Typst's `#image` embeds images as base64 inside SVG. For HTML `<img>` tags with CSS support, use the `img` helper:

```typst
#import "/utils/html.typ": img

#img("/images/photo.webp", alt: "A sunset photo", class: "mx-auto w-64")
```

#img("/images/photo.webp", alt: "A sunset photo", class: "mx-auto w-64")
