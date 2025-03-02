
// This is an example typst template (based on the default template that ships
// with Quarto). It defines a typst function named 'article' which provides
// various customization options. This function is called from the 
// 'typst-show.typ' file (which maps Pandoc metadata function arguments)
//
// If you are creating or packaging a custom typst template you will likely
// want to replace this file and 'typst-show.typ' entirely. You can find 
// documentation on creating typst templates and some examples here: 
//   - https://typst.app/docs/tutorial/making-a-template/
//   - https://github.com/typst/templates

#import "@preview/fontawesome:0.4.0": *

#let article(
  title: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "Helvetica Neue",
  fontsize: 11pt,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  doc,
) = { set page(
    margin: (left: 0.5in, right: 0.5in, top: 0.5in, bottom: 0.5in),
   // numbering: "1",
    background: {place(bottom + right,
                             text(fill: rgb(166,166,166), size: 11pt)[Updated: ] +
                             text(fill: rgb(166,166,166), size: 11pt, date),
                             dx: -0.2in, dy: -0.2in)
                      },
)
  set par(justify: false,
          leading: 0.5em)
  set block(spacing: 0.5em)
  set text(lang: lang,
           region: region,
           font: font,
           weight: "light",
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}

#show link: underline
#show link: set text(size: 11pt, weight: "light", fill: rgb(205,133,0))

#set list(marker: [--], tight: true)

// headings
#show heading: set text(11pt) // set all headings to 11pt text
#show heading.where(level: 2): set text(weight: "bold")


#show quote: set block(spacing: 1em)
#show quote: set pad(x: 2.5em)