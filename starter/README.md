# Tola Starter Template

A minimal blog template built with [Tola](https://github.com/tola-ssg/tola-ssg) and [Tailwind CSS](https://tailwindcss.com).

## Prerequisites

- [tola](https://github.com/tola-ssg/tola-ssg) - Install via `cargo install tola`
- [tailwindcss](https://tailwindcss.com/docs/installation) - Install via `npm install -g tailwindcss` or use npx

> **Note**: This template uses Tailwind CSS v4. Make sure you have the latest version installed.

## Quick Start

```sh
# Start the development server
tola serve

# Build for production
tola build
```

## Project Structure

```
.
├── tola.toml              # Tola configuration
├── content/               # Typst source files
│   ├── index.typ          # Homepage
│   └── posts/             # Blog posts
├── templates/             # Typst templates
│   └── base.typ           # Base template with styles
├── assets/
│   └── styles/
│       └── tailwind.css   # Tailwind input file
└── utils/                 # Shared Typst utilities
```

## Configuration

Edit `tola.toml` to customize:

- **Site metadata**: title, author, description
- **Build options**: minify, RSS, sitemap
- **Tailwind**: already enabled in this template
- **Deploy**: GitHub Pages settings

## Writing Posts

Create new posts in `content/posts/`:

```typst
#import "/templates/base.typ": post-template
#import "/utils/helpers.typ": *

// Best Practice: Define metadata in an args dictionary for reuse
#let args = (
  title: "My Post Title",
  date: "2024-01-15",
  tags: ("blog", "typst"),
)

#show: post-template.with(..args)

// Access metadata in content via args
This post was published on #(args.date).

```

## Customization

- **Colors**: Edit the `@theme` section in `assets/styles/tailwind.css`
- **Layout**: Modify `templates/base.typ`
- **Components**: Add reusable functions in `components/` or `utils/`

## Virtual Package Examples

Tola injects virtual packages at compile time, so you can query site data directly in Typst:

- `@tola/site:0.0.0` -> `info`
- `@tola/pages:0.0.0` -> `pages()`, `by-tag(tag)`, `by-tags(..tags)`, `all-tags()`
- `@tola/current:0.0.0` -> current page context (`permalink`, `parent-permalink`, `path`, `filename`, `breadcrumbs`, `prev`, `next`, ...)

Example usage:

```typst
#import "@tola/pages:0.0.0": pages

#let recent = (pages()
  .filter(p => "/posts/" in p.permalink)
  .filter(p => p.at("date", default: none) != none)
  .sorted(key: p => p.date)
  .rev()
  .slice(0, 5))
```

For full "code + rendered output" examples, check:

- `content/posts/virtual-packages.typ`

## Typst Tips

### Controlling Block vs. Inline Content
Typst's layout engine treats content flow as paragraphs by default. This is a powerful feature for writing text, but when generating HTML, it means Typst may wrap your loops or block elements in `<p>` tags if they appear in a text flow.

If you generate block-level HTML (like `<div>` or block `<a>`) inside a flow, browsers may alter the structure because `p` tags cannot contain block elements.

**Best Practice**: When rendering a list of block elements, wrap them in a container like `html.div(...)`. This enters "Block Mode", giving you full control over the structure.

```typst
// Implicit Paragraph Mode (Typst wraps this in <p>)
#for post in posts { ... }

// Explicit Block Mode (Clean HTML generation)
#html.div(class: "space-y-6")[
  #for post in posts { ... }
]
```

## Deploy

```sh
# Deploy to GitHub Pages
tola deploy
```

Make sure to set your repository URL in `tola.toml` under `[deploy.github]`.

## Learn More

- [Tola Documentation](https://github.com/tola-ssg/tola-ssg)
- [Typst Documentation](https://typst.app/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
