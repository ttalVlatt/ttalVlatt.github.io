
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
    margin: (left: 2in, right: 0.5in, top: 0.5in, bottom: 0.5in),
    numbering: "1",
    background: {place(left + top, 
                       rect(fill: rgb(26,26,26), 
                            height: 100%,
                            width: 1.5in,
                            place(left + top,
                                  rect(fill: gradient.linear(rgb(255,165,0),
                                                             rgb(205,133,0),
                                                             dir: ttb),
                                      height: 100%,
                                      width: 0.05in,),
                                  dx: 1.3in)
                                  )
                        );
                 place(left + top,
                       image("site-attachments/Logo.png",
                             width: 1in),
                       dx: 0.2in, dy: 0.2in
                 
                 );
                 place(left + top,
                       rotate(0deg,
                              par(text(size: 23pt,
                                       weight: "regular",
                                       fill: rgb(166,166,166))[Matt \ Capaldi \ ] +
                                  text(size: 12pt,
                                       weight: "light",
                                       fill: rgb(166,166,166))[Ph.D. Candidate],
                                        leading: 0.5em)),
                      dx: 0.1in, dy: 1.66in);
                      place(left + top,
                            rotate(0deg,
                                        fa-icon("paper-plane", fill: rgb(166,166,166), size: 9pt, solid: false) +
                                        text(fill: rgb(166,166,166))[ ] +
                                        link("mailto:m.capaldi@ufl.edu")[Email Me] +
                                        text()[ \ ] +
                                        fa-icon("phone", fill: rgb(166,166,166), size: 9pt) +
                                        text(fill: rgb(166,166,166))[ ] +
                                        link("tel:+1 (401) 601-2069")[Call Me] +
                                        text()[ \ ] +
                                        fa-icon("wifi", fill: rgb(166,166,166), size: 9pt) +
                                       text(fill: rgb(166,166,166))[ ] +
                                       link("https://capaldi.info")[Personal Website] +
                                       text()[ \ ] +
                                        fa-icon("google-scholar", fill: rgb(166,166,166), size: 9pt) +
                                        text(fill: rgb(166,166,166))[ ] +
                                        link("https://scholar.google.com/citations?user=PHk--sIAAAAJ&hl=en")[Google Scholar] +
                                        text()[ \ ] +
                                        fa-icon("orcid", fill: rgb(166,166,166), size: 9pt) +
                                        text(fill: rgb(166,166,166))[ ] +
                                        link("https://orcid.org/0000-0002-5664-3414")[ORCID] +
                                        text()[ \ ] +
                                        fa-icon("github", fill: rgb(166,166,166), size: 9pt) +
                                        text(fill: rgb(166,166,166))[ ] +
                                        link("https://github.com/ttalVlatt")[GitHub] +
                                        text()[ \ ] +
                                        fa-icon("stack-overflow", fill: rgb(166,166,166), size: 9pt) +
                                        text(fill: rgb(166,166,166))[ ] +
                                        link("https://stackoverflow.com/users/21152968/ttalvlatt")[StackOverflow]
                                        ),
                                   dx: 0.1in, dy: 2.66in);
                       place(top + right,
                             text(fill: rgb(166,166,166), size: 9pt)[Updated: ] +
                             text(fill: rgb(166,166,166), size: 9pt, date),
                             dx: -0.1in, dy: 0.1in)
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

#set table(
  inset: 6pt,
  stroke: none
)

#show link: underline
#show link: set text(size: 10pt, weight: "extralight", fill: rgb(205,133,0))

#set list(marker: [--], tight: true)

// headings
#show heading: set text(11pt) // set all headings to 12pt text
#show heading.where(level: 1): set align(left) // center level one headings
#show heading.where(level: 1): set text(weight: "regular")
#show heading.where(level: 2): set text(style: "italic")
#show heading.where(level: 4): it => text(it.body + [.]) // h/t https://github.com/mvuorre/quarto-apaish/blob/main/_extensions/apaish-document/typst-template.typ
#show heading.where(level: 5): it => text(it.body + [.], style: "italic")

#show quote: set block(spacing: 1em)
#show quote: set pad(x: 2.5em)