#import "@preview/grape-suite:3.1.0": slides
#import slides: *

#set cite(style: "ieee")

#show: slides.with(
  series: [Enterprise Software Development],
  no: 5,
  title: [Flutter],

  author: "Simon Vegelahn, Timo Schröder",
  show-semester: false,
  show-outline: true,
  text-font: "New Computer Modern",
)

#slide[
  = What is Flutter?
  - Flutter is an open-source UI software development kit created by Google.
  - It is used to develop cross platform applications for Android, iOS, Linux, MacOS, Windows, Google Fuchsia, and the web from a single codebase.
  - Written in the Dart programming language.
  - First released in May 2017.
  @flutter
]

#slide[
  = Flutter vs. Mobile
  #block(text(size: 0.65em)[
    #table(
      columns: 6,
      [*Category*],
      [*Flutter* @flutter],
      [*Android* @android],
      [*iOS* @ios],
      [*React Native* @react-native],
      [*Kotlin Multiplatform* @kmp],

      [*Cross-Platform*], [Yes], [No], [No], [Yes], [Yes],
      [*Programming Language*], [Dart], [Kotlin], [Swift], [JavaScript/TypeScript], [Kotlin + Swift],

      [*UI Development*],
      [Declarative UI with Widgets],
      [Declarative UI with Jetpack Compose],
      [Declarative UI with SwiftUI],
      [Declarative UI with Components],
      [Native UI with Platform APIs],

      [*Performance*], [Near-Native], [Native], [Native], [Near-Native], [Native],

      [*Hot Reload*], [Yes], [Yes], [Limited], [Yes], [Depends on Platform],

      [*Ecosystem Maturity*], [Growing], [Mature], [Mature], [Mature], [Emerging],
    )
  ])
]

#slide[
  = Flutter vs. Desktop
  #block(text(size: 0.65em)[
    #table(
      columns: 6,
      [*Category*],
      [*Flutter* @flutter],
      [*Electron JS* @electronjs],
      [*Tauri* @tauri],
      [*Kotlin Multiplatform* @kmp],
      [*Native*],

      [*Cross-Platform*], [Yes], [Yes], [Yes], [Yes], [No],

      [*Programming Language*],
      [Dart],
      [JavaScript/TypeScript],
      [Rust + Web Technologies],
      [Kotlin + Platform Languages],
      [C/C++, Swift, Rust, etc.],

      [*Performance*], [Near-Native], [Moderate], [High], [Native], [Native],

      [*Hot Reload*], [Yes], [Limited], [Limited], [Depends on Platform], [No],

      [*Ecosystem Maturity*], [Growing], [Mature], [Emerging], [Emerging], [Mature],
    )
  ])
]

#slide[
  = Flutter vs. Web
  #table(
    columns: 3,
    [*Category*], [*Flutter Web* @flutter], [*Web Frameworks*],

    [*Programming Language*], [Dart], [JavaScript/TypeScript],

    [*Performance*], [Moderate], [High],

    [*Hot Reload*], [Yes], [Yes],

    [*Ecosystem Maturity*], [Growing], [Mature],
  )
  #notice[In Flutter Web, text not highlightable and extensions do not work!]
]

#slide[
  = Counter Example

  - Widgets
  - Stateful vs. Stateless
]

#slide[
  = Refactored Counter Example

  - ServiceLocator Pattern
  - ValueNotifier
  - watch_it
]

#slide[
  = Exercise

  1. Location Selection
  2. Error Handling
  3. Conditional UI
  4. Input Validation _(optional)_
  5. Data Scaling _(optional)_

  Please refer to the README.md in the exercise repository for detailed instructions.
]

#slide[
  = Where to go from here?

  - Official Documentation: https://flutter.dev/docs
  - Flutter YouTube Channel: https://www.youtube.com/flutterdev
  - Dart Programming Language: https://dart.dev/guides
  - Flutter Packages: https://pub.dev/
]

#slide[
  #bibliography("sources.bib", style: "ieee", title: "References")
]
