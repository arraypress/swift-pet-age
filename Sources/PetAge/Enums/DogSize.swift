//
//  DogSize.swift
//  PetAge
//

import Foundation

/// A dog's size class by adult weight, which sets how fast it ages after two.
///
/// The classes are the ones the published charts share: under 20 lb small,
/// 20 to 50 medium, 50 to 90 large, over 90 giant. The boundaries are
/// conventions, and a 49 lb dog and a 51 lb dog do not age differently; the
/// classes exist because the difference between a 10 lb dog and a 100 lb one
/// is real and large.
public enum DogSize: String, CaseIterable, Sendable, Codable {
    case small, medium, large, giant

    /// The class for an adult weight in pounds.
    public init(weightPounds: Double) {
        self = SizeClassification.size(forPounds: weightPounds)
    }

    /// The class for an adult weight in kilograms.
    public init(weightKilograms: Double) {
        self = SizeClassification.size(forPounds: SizeClassification.pounds(fromKilograms: weightKilograms))
    }

    /// Human years gained per dog year from the third year on: 4, 5, 6 or 7.
    ///
    /// The AVMA's baseline is 5 a year for a medium dog; the size increments
    /// around it are the ones every published chart carries.
    public var annualIncrement: Double { SizeClassification.annualIncrement(for: self) }

    /// The weight range, as text: `20–50 lb`.
    public var weightRange: String { SizeClassification.weightRange(for: self) }

    /// A typical lifespan in years for the class, used only to place the
    /// AAHA senior boundary at the last quarter of life.
    ///
    /// Representative midpoints of the ranges the AKC cites — small 12–16,
    /// medium 10–13, large 8–12, giant 6–9 — and no more than that. A breed
    /// you know is better: pass it to ``PetAge/stage(dogYears:size:lifespanYears:)``.
    public var typicalLifespanYears: Double { SizeClassification.typicalLifespan(for: self) }
}
