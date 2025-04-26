#import "@preview/not-tudabeamer-2023:0.2.0": *
#import "@preview/typpuccino:0.1.0": mocha, latte

#show: not-tudabeamer-2023-theme.with(
  config-colors(background: rgb("#FF00B2")),
  config-info(
    title: [Rust],
    short-title: [Rust],
    subtitle: [Grundlagen und Konzepte],
    author: "Wölfchen",
    short-author: "Wölfchen",
    date: datetime.today(),
    department: [Ofahrt],
    institute: [D120],
    logo: image("ferris.svg"),
))

#show raw.where(block: true): block.with(
  fill: latte.mantle,
  inset: 10pt,
  radius: 4pt,
)

#set raw(
  theme: "Latte.tmTheme"
)

#title-slide()

= Brainstorming

Was macht eine Programmiersprache aus?


== Features

- Multi-Paradigm, General-Purpose
- Statisch typisiert, sehr starkes Typsystem
- Fokus auf Performance, Typsicherheit und Nebenläufigkeit
- Vom Compiler erzwungene Memory Safety
- Ohne Garbage Collector $arrow$ Bessere Laufzeitperformance und Determinismus
- Einflüsse von vielen Sprachen und Konzepten
  - Insbesondere starke Einflüsse von funktionaler Programmierung
- Zero-Cost Abstractions
- Aktiv evolvierende Standardbibliothek
- Gutes Tooling ($arrow$ Cargo)
- Großes Ökosystem durch #link("crates.io")[https://crates.io]

== Installation

Download des Toolchain-installers: #link("rustup.rs")[https://rustup.rs]

Playground zum Ausprobieren: #link("https://play.rust-lang.org")[https://play.rust-lang.org]

#linebreak()

#figure(
  ```rust
  fn main() {
      println!("Hello world!");
  }
  ```,
  caption: [Erstes Programm, erstellt mit `cargo new hello`]
)

== Cargo

- Schweizer Taschenmesser für Rust
- Normalerweise alles was man braucht
- Dependency Management, kompilieren, Tests ausführen, ...
- Bauen: `cargo build`
- Ausführen: `cargo run -- [arguments]`

== Primitive Datentypen

_Scalar data types_
- `bool`
- Ganzzahlen: `i32`, `i64`, `u32`, `usize`, ...
- Gleitkommazahlen: `f32` und `f64`
- UTF-8 Character: `char` (4 Bytes groß), UTF-8 String-Slices: `str`
- Implizite Tupel beliebiger Größe:
```rust
let my_tuple: (i32, String) = (42, String::new("hi"));
```

== Structs
```rust
struct MyStruct {
    a: bool,
    message: String,
    count: u64,
}
```
- Gruppierung von zusammengehörigen Daten beliebiger Typen
- Instanziierung über explizite Angabe für Werte für jedes Feld
  - Keine teilweise Instanziierung möglich!

== Enums

```rust
enum MyEnum {
    A,
    B,
    C(i32),
    D(String, i32, u8),
}
```
- Datentyp, der immer eine der aufgeführten Varianten sein muss
- Pattern Matching über Varianten möglich
- Im Grunde genommen eine Tagged Union

== Abwesenheit von Werten/Typen

- Alles hat einen Typ, es gibt kein `void`
- Unit Type `()`: Leeres Tupel
  - Hat genau eine Instanziierung, kann somit keine Informationen darstellen
  - Wird oft an Orten verwendet, wo in C/Java/... `void` stehen würde
- Jede Instanziierung eines Wertes ist immer korrekt
  - Es gibt kein `null`
  - Abwesenheit wird durch `Option<T>` dargestellt
  - Siehe #link(<fehlerbehandlung>)[Fehlerbehandlung]

== Variablen

```rust
let x: i32 = 42;
let mut y = 8;
```
- `let` führt Variable ein/shadowed bereits deklarierte Variable
- Type Annotations sind optional, wenn Compiler Typ inferieren kann
  - Fast immer möglich, da das Typsystem sehr stark ist
- Alles ist immutable by default, `mut` macht Dinge variabel

== Funktionen

```rust
fn do_something(i: i32, message: String, stru: MyStruct) -> Option<i32> {
    // ...
}
```
- Wenn kein `-> <type>`, Rückgabetyp implizit `()`
- `return <expression>;`, um Wert zurückzugeben

== Fehlerbehandlung <fehlerbehandlung>

- Rust hat keine Exceptions, diese führen immer versteckte Kontrollflusspfade ein
- Fehlerbehandlung v.a. durch 2 Enums aus der Standardbibliothek
- Durch Pattern Matching und Compiler-Zwang sehr stark
- Viele Hilfsfunktionen und teilweise auch Sprachkonstrukte

#columns(2,[
  ```rust
  // Grob vereinfacht
  enum Option<T> {,
      Some(T),
      None,
  }
  enum Result<T, E> {
      Ok(T),
      Err(E),
  }
  ```
  #colbreak()
  - `Option` wird verwendet, wenn ein Wert abwesend sein kann
  - `Result` wird verwendet, wenn eine Operation fehlschlagen kann
])

== Blöcke

- Erinnerung: Alles hat einen Wert!
  $\to$ Logische Schlussfolgerung: Auch Blöcke haben einen Wert
- Blöcke sind Ausdrücke
- Default: `()`
- Ausdruck ohne `;` am Ende eines Blockes $\to$ Block evaluiert zu diesem Wert
  - Auch bei Funktionen möglich
```rust
let x = {
    // arbitrary code can be put here
    let a = 9;
    a + 6
};
// x has value 15
```

== `if`-Ausdruck
```rust
let number = 6;
// statement-like usage
if number % 4 == 0 {
    println!("number is divisible by 4");
} else if number % 3 == 0 {
    println!("number is divisible by 3");
} else {
    println!("number is not divisible by 4 or 3");
}
// if is just an expression
let y = if number == 4 { 3 } else { 23245 };
```
- Evaluiert abhängig von Konditionen zur ersten Alternative, die `true` ist

== Schleifen
```rust
loop {
    // ...
    break;
}

while true { ... }

let a = [10, 20, 30, 40, 50];
for element in a {
    println!("the value is: {element}");
}
// equivalent
for element in (1..6).map(|n| n * 10) {
    println!("{element}");
}
```

== Pattern Matching
```rust
// again, everything is an expression
let x = match my_enum_value {
    MyEnum::A => 5,
    MyEnum::C(n) => n,
    MyEnum::D(_, i, u) => i + u,
    _ => {
      println!("unknown enum variant!");
      0
    },
};
```
- Vergleiche Wert mit einer List an Patterns
- Alle Möglichkeiten müssen behandelt werden, sonst lehnt Compiler Code ab
- Destructuring und Binden von Werten an Variablen möglich
- Erstes Match bestimmt Konsequenzen

== Ownership
_Rusts Modell für sicheres Memory Management ohne Garbage Collector_

Es gibt 3 Regeln:
1. Jeder Wert hat einen Owner
2. Es kann zu jedem Zeitpunkt nur einen Owner geben
3. Wenn der Owner out of Scope geht, wird der Wert gedropped

- Wird vom Compiler erzwungen:
  Programme, die diese Regeln verletzen, kompilieren nicht
- Owner sind z.B. Variablen oder Funktionen, wenn sie Werte als Parameter erhalten

== Borrowing
- Immer Werte übergeben skaliert logischerweise nicht $arrow$ verwende Referenzen
- Referenzen sind wie Pointer, haben aber die Garantie, dass der Speicher valid ist
```rust
fn calculate_length(s: &str) -> usize {
    s.len()
}
// call site
let s = String::from("hi");
let length = calculate_length(&s);
```

== Traits

- Grundlegende Idee ähnlich zu Java Interfaces
- Drücken Eigenschaften aus, die Typen haben
- Ermöglichen Polymorphismus

```rust
pub trait MyTrait {
    fn do_the_thing(&self) -> i32;
}

impl MyTrait for String {
    fn do_the_thing(&self) -> i32 {
      self.len() as i32
    }
}
```


/*
---
# Programmiersprachen
## Was macht sie besonders?

---
# Rusts Features
- Multi-Paradigm, General-Purpose
- Statisch typisiert, sehr starkes Typsystem
- Fokus auf Performance, Typsicherheit und Nebenläufigkeit
- Vom Compiler erzwungene Memory Safety
- Ohne Garbage Collector $\to$ Bessere Laufzeitperformance
- Einflüsse von vielen Sprachen und Konzepten
- Insbesondere starke Einflüsse von funktionaler Programmierung
- Zero-Cost Abstractions
- Große Standardbibliothek
- Gutes Tooling ($\to$ Cargo)
- Großes Ökosystem durch [crates.io](https://crates.io)

---
# Installation
[rustup.rs](https://rustup.rs)
```rust
fn main() {
    println!("Hello world!");
}
```
*Erstes Programm, erstellt mit `cargo new hello`*

---
# Cargo
- Schweizer Taschenmesser für Rust
- Normalerweise alles was man braucht
- Dependency Management, kompilieren, Tests ausführen, ...
- Bauen: `cargo build`
- Ausführen: `cargo run -- [arguments]`

---
# Primitive Datentypen
## Scalar data types
- `bool`
- Ganzzahlen: `i32`, `i64`, `u32`, `usize`, ...
- Gleitkommazahlen: `f32` und `f64`
- UTF-8 Character: `char` (4 Bytes groß)
- Implizite Tupel beliebiger Größe:
```rust
let my_tuple: (i32, String) = (42, String::new("hi"));
```

---
# Zusammengesetzte Datentypen
## Compound data types
## Structs
```rust
struct MyStruct {
    a: bool,
    message: String,
    count: u64,
}
```
- Gruppierung von zusammengehörigen Daten beliebiger Typen
- Instanziierung über explizite Angabe für Werte für jedes Feld
  $\to$ Keine teilweise Instanziierung möglich!

---
## Enums
```rust
enum MyEnum {
    A,
    B,
    C(i32),
    D(String, i32, u8),
}
```
- Datentyp, der immer eine der aufgeführten Varianten sein muss
- Pattern Matching über Varianten möglich

---
# :warning: Theorie :warning:
- Alles hat einen Typ $\to$ Es gibt kein `void`
- Unit Type `()`: Leeres Tupel
  - Hat genau eine Instanziierung
  - Wird oft an Orten verwendet, wo in C/Java `void` stehen würde

---
# Variablen
```rust
let x: i32 = 42;
let mut y = 8;
```
- `let` führt Variable ein/shadowed bereits deklarierte Variable
- Type Annotations sind optional, wenn Compiler Typ inferieren kann
  - Fast immer möglich, da das Typsystem sehr stark ist
- Alles ist immutable by default, `mut` macht Dinge variabel

---
# Funktionen
```rust
fn do_something(i: i32, message: String, stru: MyStruct) -> Option<i32> {
    // ...
}
```
- Wenn kein `-> <type>`, Rückgabetyp implizit Unit
- `return <expression>;`, um Wert zurückzugeben

---
# Fehlerbehandlung
- Rust hat keine Exceptions, diese führen immer versteckte Kontrollflusspfade ein
- Fehlerbehandlung v.a. durch 2 Enums aus der Standardbibliothek
- Option wird verwendet, wenn ein Wert abwesend sein kann $\to$ kein `null`
- Durch Pattern Matching und Compiler-Zwang sehr stark
```rust
// Grob vereinfacht
enum Option<T> {,
    Some(T),
    None,
}
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```
- Haufenweise Hilfsfunktionen und teilweise auch Sprachkonstrukte
- Immer automatisch importiert und in Scope

---
# Blöcke
- Erinnerung: Alles hat einen Wert!
  $\to$ Logische Schlussfolgerung: Auch Blöcke haben einen Wert
- Blöcke sind Ausdrücke
- Default: `()`
- Ausdruck ohne `;` am Ende eines Blockes $\to$ Block evaluiert zu diesem Wert
  - Auch bei Funktionen möglich
```rust
let x = {
    // arbitrary code can be put here
    let a = 9;
    a + 6
};
// x has value 15
```

---
# Kontrollfluss
## `if`-Ausdruck
```rust
let number = 6;
// statement-like usage
if number % 4 == 0 {
    println!("number is divisible by 4");
} else if number % 3 == 0 {
    println!("number is divisible by 3");
} else {
    println!("number is not divisible by 4 or 3");
}
// if is just an expression
let y = if number == 4 { 3 } else { 23245 };
```
- Evaluiert abhängig von Konditionen zur ersten Alternative, die `true` ist

---
# Schleifen
```rust
loop {
    // ...
    break;
}
let condition = true;
while condition {
    // ...
}
let a = [10, 20, 30, 40, 50];
for element in a {
    println!("the value is: {element}");
}
// equivalent
for element in (1..6).map(|n| n * 10) {
    println!("{element}");
}
```

---
# Ownership
## Rusts Modell für Memory Management ohne Garbage Collector
Es gibt 3 Regeln:
1. Jeder Wert hat einen Owner
2. Es kann zu jedem Zeitpunkt nur einen Owner geben
3. Wenn der Owner out of Scope geht, wird der Wert gedropped

- Wird vom Compiler erzwungen:
  Programme, die diese Regeln verletzen, kompilieren nicht
- Owner sind z.B. Variablen oder Funktionen, wenn sie Werte als Parameter erhalten

---
# Borrowing
- Immer Werte übergeben skaliert logischerweise nicht $\to$ Referenzen
- Referenzen sind wie Pointer, haben aber die Garantie, dass der Speicher valid ist
```rust
fn calculate_length(s: &String) -> usize {
    s.len()
}
// call site
let s = String::from("hi");
let length = calculate_length(&s);
```

---
# Pattern Matching
```rust
let x = match my_enum_value {
    MyEnum::A => 5,
    MyEnum::C(n) => n,
    MyEnum::D(_, i, u) => i + u,
    _ => {
      println!("unknown enum variant!");
      0
    },
};
```
- Vergleiche Wert mit einer List an Patterns
- Alle Möglichkeiten müssen behandelt werden
- Destructuring und Binden von Werten an Variablen möglich
- Erstes Match bestimmt Konsequenzen
- Wie `if` als Expression und Statement verwendbar

---
# Traits
- Grundlegende Idee ähnlich zu Java Interfaces
```rust
pub trait MyTrait {
    fn do_the_thing(&self) -> i32;
}

impl MyTrait for String {
    fn do_the_thing(&self) -> i32 {
      self.len() as i32
    }
}
```

---
# Ressourcen
- Das Buch: [https://doc.rust-lang.org/book/](https://doc.rust-lang.org/book/)
- Rust By Example: [https://doc.rust-lang.org/rust-by-example/](https://doc.rust-lang.org/rust-by-example/)
- Rustlings: [https://github.com/rust-lang/rustlings](https://github.com/rust-lang/rustlings)
*/
