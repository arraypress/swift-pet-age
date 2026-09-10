# Swift Pet Age

A dog's or cat's age in human years the way veterinary bodies count it, and the life stage it puts them in — as typed values, on any Apple platform.

```swift
import PetAge

try PetAge.humanYears(dogYears: 7, size: .large)              // 54
try PetAge.humanYears(dogYears: 7, size: .small)              // 44 — not 49, not 7 × 7
try PetAge.humanYears(catYears: 10)                           // 56
try PetAge.stage(dogYears: 6, size: .giant)                   // .senior — the last quarter of eight years
try PetAge.stage(catYears: 10.5)                              // .senior

try PetAge.convert(try Age(years: 2, months: 6), of: .dog, size: DogSize(weightKilograms: 30))
// petYears 2.5, humanYears 27, stage "youngAdult", size .large

try PetAge.humanYears(dogYears: 4, method: .epigenetic)       // 53.2 — the 2020 DNA-methylation formula
```

## Why

| Question | The wrong answer, and why it is tempting |
|---|---|
| A seven-year-old dog in human years | 49. "Times seven" is the rule everybody knows and no veterinary body uses. It is 44 for a small dog and 59 for a giant one. |
| Does a Chihuahua age like a Great Dane? | The same number for both. After two, a small dog gains four human years a year and a giant breed seven, which is why one is senior at ten and the other at six. |
| When is a dog senior? | A fixed age. The AAHA defines it as the last quarter of the expected lifespan, precisely because that quarter starts at six for a giant breed and at ten and a half for a small one. |
| What about the "new formula"? | Treating it as the correct one. `16 · ln(age) + 31` came from 104 Labradors, and its authors say your dog may not match it. It is here as the alternative people ask about. |
| A two-and-a-half-year-old | Rounding to two, or to three. Six months on a small dog is two human years. |

## Installation

```swift
.package(url: "https://github.com/arraypress/swift-pet-age.git", from: "0.1.0")
```

Foundation only. No dependencies, every Apple platform, macOS 14+.

## Dogs

```swift
try PetAge.humanYears(dogYears: 3, size: .medium)      // 29
try PetAge.dogYears(forHumanYears: 29, size: .medium)  // 3 — the chart backwards
DogSize(weightPounds: 55)                              // .large
DogSize(weightKilograms: 4)                            // .small
DogSize.giant.annualIncrement                          // 7
```

The chart is the American Veterinary Medical Association's baseline — fifteen human years
for the first year, nine for the second, then five a year for a medium dog — with the size
increments every published chart carries around it: four a year for small dogs, five for
medium, six for large, seven for giant. Small is under 20 lb, medium 20 to 50, large 50 to
90, giant over 90; the weight initialisers do the sorting, and the shared numbers are
documented in the code rather than left ambiguous.

`.epigenetic` is Wang et al. 2020 (*Cell Systems*): `16 · ln(age) + 31`, floored at zero
below about seven weeks where the logarithm goes negative. It says a one-year-old is 31 and a
sixteen-year-old 75 — front-loaded against the chart and flatter later. It is not inverted,
because it was fitted one way.

## Cats

```swift
try PetAge.humanYears(catYears: 2)      // 24
try PetAge.humanYears(catYears: 15)     // 76
try PetAge.catYears(forHumanYears: 56)  // 10
```

Fifteen for the first year, nine for the second, four a year after — the conversion the
2021 AAHA/AAFP Feline Life Stage Guidelines use. No size classes: a Maine Coon and a
Singapura age on the same line.

## Life stages

```swift
try PetAge.stage(dogYears: 0.5)                                // .puppy
try PetAge.stage(dogYears: 9, size: .medium)                   // .senior — the last quarter of twelve
try PetAge.stage(dogYears: 9, size: .medium, lifespanYears: 16) // .matureAdult — a breed you know
try PetAge.stage(catYears: 7)                                  // .matureAdult
DogLifeStage.youngAdult.label                                  // "Young adult"
```

Dogs follow the 2019 AAHA Canine Life Stage Guidelines: puppy to the end of rapid growth
(taken as nine months), young adult to physical and social maturity (three and a half),
mature adult until the beginning of the last 25% of the expected lifespan, and senior from
there. The lifespan is the size's typical figure — 14, 12, 10 and 8 years, midpoints of the
ranges the AKC cites — unless you pass one for the breed, which is better.

Cats follow the 2021 AAHA/AAFP guidelines: kitten under one, young adult from one to six,
mature adult from seven to ten, senior over ten. "Over ten" is strict: ten years and a day is
senior; exactly ten is not yet.

## What this is not

A convention, cited. Not a prediction about one animal — breed, weight, diet and luck move
any individual off every chart — and not veterinary advice.

## Tested

29 tests, every one a fixed age against a published figure: all 72 cells of the chart and the
chart run backwards through every one of them, months at each size's rate, the epigenetic
formula at its published points and its zero crossing, every stage boundary for every size
and for cats, a breed lifespan overriding the typical one, the weight bands in pounds and
kilograms at their edges, every refusal with its message, and every model and enum through
JSON.

## Licence

MIT.
