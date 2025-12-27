// Base template with shared configuration and layout
// Import: #import "/templates/base.typ": base, colors

#import "/utils/helpers.typ" as utils

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

  show raw.where(block: false): it => html.code(class: "font-semibold " + colors.code)[#it.text]

  // Default: Typst native syntax highlighting
  // Note: The inner <pre> tag already has background/padding styles from tailwind.css.
  // We wrap it in a div primarily for margins and the border.
  show raw.where(block: true): it => html.div(
    class: "my-2 border border-white/10 rounded-lg",
  )[#it]

  // --------------------------------------------------------------------------
  // Show Rules: Text Elements
  // --------------------------------------------------------------------------

  show quote: it => html.blockquote(class: "border-l-4 border-accent pl-4 my-4 italic " + colors.muted)[#it.body]
  show link: it => html.a(
    class: "underline underline-offset-4 hover:" + colors.accent,
    href: repr(it.dest).replace("\"", ""),
  )[#it.body]
  show strike: it => html.del[#it.body]
  show image: html.frame

  // --------------------------------------------------------------------------
  // Show Rules: Math
  // --------------------------------------------------------------------------

  // Set math font
  show math.equation: set text(font: "Luciole Math", features: (ss01: 1))

  let inside-figure = state("inside-figure", false)

  show figure: it => {
    inside-figure.update(true)
    html.figure(class: "my-6 mx-auto w-fit")[#it]
    inside-figure.update(false)
  }
  show math.equation.where(block: false): it => context {
    if not inside-figure.get() { html.span(class: "inline-flex align-middle", role: "math")[#html.frame(it)] } else {
      it
    }
  }
  show math.equation.where(block: true): it => context {
    if not inside-figure.get() { html.figure(class: "my-6 flex justify-center", role: "math")[#html.frame(it)] } else {
      it
    }
  }

  // --------------------------------------------------------------------------
  // Render
  // --------------------------------------------------------------------------

  html.main(class: "max-w-3xl mx-auto px-4 py-8")[#body]
}

