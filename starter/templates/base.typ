// Base template with shared configuration and layout
// Import: #import "/templates/base.typ": base, colors

#import "/templates/tola.typ" as tola
#import "/utils/tola.typ": cls

// ============================================================================
// Configuration
// ============================================================================

#let colors = (
  accent: "text-cyan-400",
  code: "text-purple-300",
  muted: "text-slate-400",
)

// ============================================================================
// Base Layout
// ============================================================================

#let base(body) = {
  // --------------------------------------------------------------------------
  // Inherit Tola base (figure/table/math handling)
  // --------------------------------------------------------------------------

  show: tola.tola-base.with(
    figure-class: "my-6 mx-auto w-fit",
    // Keep inline math in normal inline formatting context so SVG
    // `vertical-align` baseline offsets are effective.
    math-inline-class: "inline-block align-baseline text-lg",
    math-block-class: "my-6 flex justify-center text-2xl",
    math-font: "Luciole Math",
  )

  // --------------------------------------------------------------------------
  // Show Rules: Lists
  // --------------------------------------------------------------------------

  show list: it => html.ul(class: "list-disc ml-6 my-4 space-y-1")[
    #for item in it.children { html.li[#item.body] }
  ]
  show enum: it => html.ol(class: "list-decimal ml-6 my-4 space-y-1")[
    #for item in it.children { html.li[#item.body] }
  ]

  // --------------------------------------------------------------------------
  // Show Rules: Code
  // --------------------------------------------------------------------------

  show raw.where(block: false): it => html.code(class: cls("font-semibold", colors.code))[#it.text]

  // Default: Typst native syntax highlighting
  // Note: The inner <pre> tag already has background/padding styles from tailwind.css.
  // We wrap it in a div primarily for margins and the border.
  show raw.where(block: true): it => html.div(
    class: "my-2 border border-white/10 rounded-lg",
  )[#it]

  // --------------------------------------------------------------------------
  // Show Rules: Text Elements
  // --------------------------------------------------------------------------

  show quote: it => html.blockquote(class: cls("border-l-4 border-accent pl-4 my-4 italic", colors.muted))[#it.body]
  show link: it => html.a(
    class: cls("underline underline-offset-4", "hover:" + colors.accent),
    href: repr(it.dest).replace("\"", ""),
  )[#it.body]

  // --------------------------------------------------------------------------
  // Render
  // --------------------------------------------------------------------------

  html.main(class: "max-w-3xl mx-auto px-4 py-8")[#body]
}
