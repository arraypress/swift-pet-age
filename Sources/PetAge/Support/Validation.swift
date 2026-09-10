//
//  Validation.swift
//  PetAge
//

import Foundation

/// The checks on the way in, and the one piece of arithmetic an Age needs.
enum Validation {

    /// Years are zero or more and finite.
    static func check(years: Double) throws {
        guard years >= 0, years.isFinite else { throw PetAgeError.badAge(years) }
    }

    /// A lifespan is above zero and finite.
    static func check(lifespan: Double) throws {
        guard lifespan > 0, lifespan.isFinite else { throw PetAgeError.badAge(lifespan) }
    }

    /// Whole years zero or more, months 0–11.
    static func check(years: Int, months: Int) throws {
        guard years >= 0 else { throw PetAgeError.badAge(Double(years)) }
        guard (0...11).contains(months) else { throw PetAgeError.badMonths(months) }
    }

    /// Years plus months as a decimal.
    static func totalYears(years: Int, months: Int) -> Double {
        Double(years) + Double(months) / 12
    }
}
