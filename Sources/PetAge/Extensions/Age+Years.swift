//
//  Age+Years.swift
//  PetAge
//

import Foundation

extension Age {

    /// The age as a decimal number of years: one year six months is `1.5`.
    public var totalYears: Double { Validation.totalYears(years: years, months: months) }
}
