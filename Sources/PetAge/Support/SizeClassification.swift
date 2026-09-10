//
//  SizeClassification.swift
//  PetAge
//
//  Weight to size class, and the figures each class carries.
//

import Foundation

/// The size-class table.
enum SizeClassification {

    /// Under 20 lb small, 20 to under 50 medium, 50 to 90 large, over 90 giant.
    ///
    /// The published charts write the bands as "20–50" and "50–90" and leave
    /// the shared number ambiguous; here a boundary weight goes to the lower
    /// band's neighbour above, except 90, which the charts write as "over 90"
    /// for giant and so stays large.
    static func size(forPounds pounds: Double) -> DogSize {
        if pounds < 20 { return .small }
        if pounds < 50 { return .medium }
        if pounds <= 90 { return .large }
        return .giant
    }

    /// One kilogram is 2.20462 pounds.
    static func pounds(fromKilograms kilograms: Double) -> Double {
        kilograms * 2.20462
    }

    /// Human years per dog year after the second.
    static func annualIncrement(for size: DogSize) -> Double {
        switch size {
        case .small: 4
        case .medium: 5
        case .large: 6
        case .giant: 7
        }
    }

    /// The band as text.
    static func weightRange(for size: DogSize) -> String {
        switch size {
        case .small: "under 20 lb"
        case .medium: "20–50 lb"
        case .large: "50–90 lb"
        case .giant: "over 90 lb"
        }
    }

    /// Representative lifespans: midpoints of the ranges the AKC cites.
    static func typicalLifespan(for size: DogSize) -> Double {
        switch size {
        case .small: 14
        case .medium: 12
        case .large: 10
        case .giant: 8
        }
    }
}
