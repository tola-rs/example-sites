// HTML element utilities for Typst
//
// Use these instead of #image when you need HTML attributes like class.

/// Create an <img> element with class support.
///
/// Example:
/// ```typst
/// #img("/images/photo.webp", alt: "A sunset", class: "mx-auto w-64")
/// ```
#let img(src, alt: none, class: none) = {
  let a = (src: src)
  if alt != none { a.insert("alt", alt) }
  if class != none { a.insert("class", class) }
  html.elem("img", attrs: a)
}
