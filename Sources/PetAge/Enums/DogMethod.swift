//
//  DogMethod.swift
//  PetAge
//

import Foundation

/// The two published ways to put a dog's age in human years.
public enum DogMethod: String, CaseIterable, Sendable, Codable {

    /// The chart: 15 for the first year, 9 for the second, then 4 to 7 a year
    /// by size. The AVMA's baseline with the size increments every chart uses.
    case sizeAdjusted

    /// `16 · ln(age) + 31`, from Wang et al. 2020 (*Cell Systems*), who
    /// compared the DNA-methylation clocks of 104 Labrador Retrievers with
    /// humans'. It says a one-year-old dog is 31, a four-year-old 53 and a
    /// sixteen-year-old 75 — front-loaded, and flatter later than the chart.
    /// One breed was studied, and the authors say so; it is here as the
    /// alternative people ask about, not as the better answer.
    case epigenetic
}
