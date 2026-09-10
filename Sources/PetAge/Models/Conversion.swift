//
//  Conversion.swift
//  PetAge
//

import Foundation

/// One animal's age, converted, with the stage it puts them in.
public struct Conversion: Sendable, Hashable, Codable {

    /// Dog or cat.
    public let species: Species

    /// The animal's age in its own years, as a decimal.
    public let petYears: Double

    /// The equivalent human age.
    public let humanYears: Double

    /// The life stage, as its raw name: `puppy`, `youngAdult`, `senior`, `kitten`.
    public let stage: String

    /// The size class used, for a dog; nil for a cat.
    public let size: DogSize?

    /// The method used, for a dog; nil for a cat.
    public let method: DogMethod?
}
