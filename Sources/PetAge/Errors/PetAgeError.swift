//
//  PetAgeError.swift
//  PetAge
//

import Foundation

/// What was refused, in words a caller can print unchanged.
public enum PetAgeError: Error, LocalizedError, Equatable, Sendable {

    /// A negative or non-finite number of years, or a lifespan at or below zero.
    case badAge(Double)

    /// Months outside 0–11.
    case badMonths(Int)

    public var errorDescription: String? {
        switch self {
        case .badAge(let years):
            return "not an age: \(years) years\nages and lifespans are zero or more years; twelve months is a year"
        case .badMonths(let months):
            return "not a number of months past a birthday: \(months)\nuse 0–11; twelve months is another year"
        }
    }
}
