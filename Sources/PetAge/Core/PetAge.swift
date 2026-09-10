//
//  PetAge.swift
//  PetAge
//
//  The namespace: a dog's or cat's age in human years, and its life stage.
//

import Foundation

/// A dog's or cat's age in human years, the way veterinary bodies count it.
///
/// "Multiply by seven" is the answer everybody knows and nobody in veterinary
/// medicine uses. A dog is an adolescent at one and an adult at two — fifteen
/// and twenty-four in human terms — and after that a Chihuahua and a Great
/// Dane age at visibly different rates. So the conversion is piecewise, and
/// for dogs it depends on size. Cats follow the same first two years and then
/// a steady four.
///
/// Two things this is and is not. It is the published convention — the AVMA's
/// baseline with the size increments every chart uses, the AAHA and AAFP life
/// stages, and the 2020 epigenetic formula as an alternative for dogs. It is
/// not a prediction about one animal: breed, weight and luck move any
/// individual off the chart.
public enum PetAge {

    /// A dog's age in human years.
    ///
    /// ``DogMethod/sizeAdjusted`` by default: 15 for the first year, 9 for the
    /// second, then 4, 5, 6 or 7 a year by size. The size matters because
    /// large dogs age faster in their adult years — a giant breed is senior
    /// at six — and a single multiplier hides that.
    ///
    /// - Throws: ``PetAgeError/badAge(_:)`` for a negative or non-finite age.
    public static func humanYears(
        dogYears: Double, size: DogSize = .medium, method: DogMethod = .sizeAdjusted
    ) throws -> Double {
        try Validation.check(years: dogYears)
        switch method {
        case .sizeAdjusted: return DogYears.sizeAdjusted(dogYears: dogYears, increment: size.annualIncrement)
        case .epigenetic: return DogYears.epigenetic(dogYears: dogYears)
        }
    }

    /// A cat's age in human years: 15 for the first year, 9 for the second,
    /// then 4 a year — the conversion the 2021 AAHA/AAFP feline life stage
    /// guidelines use.
    ///
    /// - Throws: ``PetAgeError/badAge(_:)`` for a negative or non-finite age.
    public static func humanYears(catYears: Double) throws -> Double {
        try Validation.check(years: catYears)
        return CatYears.humanYears(catYears: catYears)
    }

    /// The dog age that corresponds to a human age, by the size-adjusted chart.
    ///
    /// The inverse of ``humanYears(dogYears:size:method:)`` for the chart
    /// method only; the epigenetic curve is not inverted because it was fitted
    /// one way and reads badly the other.
    ///
    /// - Throws: ``PetAgeError/badAge(_:)`` for a negative or non-finite age.
    public static func dogYears(forHumanYears humanYears: Double, size: DogSize = .medium) throws -> Double {
        try Validation.check(years: humanYears)
        return DogYears.inverseSizeAdjusted(humanYears: humanYears, increment: size.annualIncrement)
    }

    /// The cat age that corresponds to a human age.
    ///
    /// - Throws: ``PetAgeError/badAge(_:)`` for a negative or non-finite age.
    public static func catYears(forHumanYears humanYears: Double) throws -> Double {
        try Validation.check(years: humanYears)
        return CatYears.inverse(humanYears: humanYears)
    }

    /// Which of the AAHA's four canine life stages a dog is in.
    ///
    /// Puppy to nine months, young adult to three and a half, mature adult
    /// until the last quarter of the expected lifespan, senior after — the
    /// 2019 AAHA Canine Life Stage Guidelines, which define senior by the
    /// lifespan rather than a fixed age precisely because a giant breed's
    /// last quarter starts at six. Pass `lifespanYears` for a breed you know;
    /// otherwise the size's typical figure is used.
    ///
    /// - Throws: ``PetAgeError/badAge(_:)`` for a negative or non-finite age
    ///   or a lifespan at or below zero.
    public static func stage(
        dogYears: Double, size: DogSize = .medium, lifespanYears: Double? = nil
    ) throws -> DogLifeStage {
        try Validation.check(years: dogYears)
        let lifespan = lifespanYears ?? size.typicalLifespanYears
        try Validation.check(lifespan: lifespan)
        return DogYears.stage(dogYears: dogYears, lifespanYears: lifespan)
    }

    /// Which of the AAHA/AAFP's four feline life stages a cat is in: kitten
    /// under one, young adult from one to six, mature adult from seven to
    /// ten, senior past ten.
    ///
    /// - Throws: ``PetAgeError/badAge(_:)`` for a negative or non-finite age.
    public static func stage(catYears: Double) throws -> CatLifeStage {
        try Validation.check(years: catYears)
        return CatYears.stage(catYears: catYears)
    }

    /// Everything at once for an animal of a known age.
    ///
    /// - Throws: ``PetAgeError/badAge(_:)`` for a bad lifespan; the age
    ///   itself was checked when the ``Age`` was made.
    public static func convert(
        _ age: Age, of species: Species, size: DogSize = .medium,
        method: DogMethod = .sizeAdjusted, lifespanYears: Double? = nil
    ) throws -> Conversion {
        let years = age.totalYears
        switch species {
        case .dog:
            return Conversion(
                species: .dog,
                petYears: years,
                humanYears: try humanYears(dogYears: years, size: size, method: method),
                stage: try stage(dogYears: years, size: size, lifespanYears: lifespanYears).rawValue,
                size: size,
                method: method
            )
        case .cat:
            return Conversion(
                species: .cat,
                petYears: years,
                humanYears: try humanYears(catYears: years),
                stage: try stage(catYears: years).rawValue,
                size: nil,
                method: nil
            )
        }
    }
}
