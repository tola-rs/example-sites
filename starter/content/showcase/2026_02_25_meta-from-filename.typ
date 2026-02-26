#import "/templates/showcase/meta-from-filename.typ": meta-from-filename-post

#show: meta-from-filename-post.with(
  title: "Derive Date And Permalink From Filename",
  summary: "Extract both `date` and `permalink` from `@tola/current.path` + `filename`.",
  author: "Tola",
  tags: ("showcase", "feature"),
  // date and permalink are inferred from this file's name.
)

= Introduction

This post demonstrates the `path` and `filename` fields in `@tola/current`.

For `2026_02_25_meta-from-filename.typ`, the template infers:

- `date` from the `YYYY_MM_DD` prefix
- `permalink` from directory + slug (remaining filename parts)

= How It Works

`path` provides the source file path relative to the content directory, and `filename` provides the last segment:

```typst
#import "@tola/current:0.0.0": path, filename
// path = "showcase/2026_02_25_meta-from-filename.typ"
// filename = "2026_02_25_meta-from-filename.typ"
```

You can parse the filename to extract the date:

```typst
#let parts = filename.split("_")
#let date = datetime(
  year: int(parts.at(0)),
  month: int(parts.at(1)),
  day: int(parts.at(2)),
)
```

And derive the permalink from `path` + parsed slug:

```typst
// skip YYYY_MM_DD, keep slug part
#let slug = parts.slice(3).join("-")

// remove filename, keep directory
#let dir = path.split("/").slice(0, -1).join("/")

// permalink: "/slug/" or "/dir/slug/"
#let permalink = if dir == "" {
  "/" + slug + "/"
} else {
  "/" + dir + "/" + slug + "/"
}
```

= Benefits

- File names can include dates for chronological sorting in file managers
- URLs remain clean without date prefixes (auto-derived from slug)
- `date` and `permalink` stay derived from one source (no duplication)
