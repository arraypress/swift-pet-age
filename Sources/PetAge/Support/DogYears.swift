//
//  DogYears.swift
//  PetAge
//
//  The dog arithmetic, on plain numbers.
//

import Foundation

/// Human years for dog years, both ways, and the life stage.
enum DogYears {

    /// Piecewise linear: 15 a year to one, 9 for the second year, then the
    /// size's increment. Months count, so a year and a half on a small dog is
    /// 15 + 4.5.
    static func sizeAdjusted(dogYears years: Double, increment: Double) -> Double {
        if years <= 1 { return 15 * years }
        if years <= 2 { return 15 + 9 * (years - 1) }
        return 24 + increment * (years - 2)
    }

    /// `16 · ln(age) + 31`, floored at zero — the curve goes negative under
    /// about seven weeks, which is the formula's edge, not a puppy's.
    static func epigenetic(dogYears years: Double) -> Double {
        guard years > 0 else { return 0 }
        return max(0, 16 * log(years) + 31)
    }

    /// The chart run backwards: which dog age gives this human age.
    static func inverseSizeAdjusted(humanYears human: Double, increment: Double) -> Double {
        if human <= 15 { return human / 15 }
        if human <= 24 { return 1 + (human - 15) / 9 }
        return 2 + (human - 24) / increment
    }

    /// The AAHA stage: puppy under nine months, young adult under three and a
    /// half, mature adult until the last quarter of the lifespan, then senior.
    static func stage(dogYears years: Double, lifespanYears lifespan: Double) -> DogLifeStage {
        if years < 0.75 { return .puppy }
        if years < 3.5 { return .youngAdult }
        if years < lifespan * 0.75 { return .matureAdult }
        return .senior
    }
}
