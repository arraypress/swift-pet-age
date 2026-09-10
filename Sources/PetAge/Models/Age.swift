//
//  Age.swift
//  PetAge
//

import Foundation

/// An age in whole years and months, the way an owner states it.
///
/// "Two and a half" is two years and six months, and the half matters: a
/// small dog gains four human years per dog year, so six months is two of
/// them. Held as two integers rather than a fraction so `1 year 6 months`
/// cannot arrive as `1.5` when the owner meant `1.6`.
public struct Age: Sendable, Hashable, Codable {

    /// Whole years, zero or more.
    public let years: Int

    /// Months past the last birthday, 0–11.
    public let months: Int

    /// An age, checked.
    ///
    /// - Throws: ``PetAgeError/badMonths(_:)`` for months outside 0–11 — twelve
    ///   months is a year, and saying so is the caller's job — and
    ///   ``PetAgeError/badAge(_:)`` for negative years.
    public init(years: Int, months: Int = 0) throws {
        try Validation.check(years: years, months: months)
        self.years = years
        self.months = months
    }
}
