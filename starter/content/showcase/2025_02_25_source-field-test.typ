#import "/templates/showcase/dated-post.typ": dated-post

#show: dated-post.with(
  title: "Testing @tola/current.source",
  summary: "Demonstrates extracting date from filename using the new source field",
  author: "Tola",
  tags: ("showcase", "feature"),
  // Note: date and permalink are NOT set here - they will be parsed from filename!
)

= Introduction

This post demonstrates the new `source` field in `@tola/current` package.

The filename is `2025_02_25_source-field-test.typ`, and the date is automatically extracted from it.

= How It Works

The `source` field provides the source file path relative to the content directory:

```typst
#import "@tola/current:0.0.0": source
// source = "showcase/2025_02_25_source-field-test.typ"
```

You can then parse the filename to extract the date:

```typst
#let parts = source.split("/").last().split("_")
#let date = datetime(
  year: int(parts.at(0)),
  month: int(parts.at(1)),
  day: int(parts.at(2)),
)
```

= Benefits

- File names can include dates for chronological sorting in file managers
- URLs remain clean without date prefixes (auto-derived from slug)
- Date is the single source of truth (no duplication)
