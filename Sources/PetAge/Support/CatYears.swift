//
//  CatYears.swift
//  PetAge
//
//  The cat arithmetic, on plain numbers.
//

import Foundation

/// Human years for cat years, both ways, and the life stage.
enum CatYears {

    /// 15 a year to one, 9 for the second year, then 4 a year.
    static func humanYears(catYears years: Double) -> Double {
        if years <= 1 { return 15 * years }
        if years <= 2 { return 15 + 9 * (years - 1) }
        return 24 + 4 * (years - 2)
    }

    /// The conversion run backwards.
    static func inverse(humanYears human: Double) -> Double {
        if human <= 15 { return human / 15 }
        if human <= 24 { return 1 + (human - 15) / 9 }
        return 2 + (human - 24) / 4
    }

    /// The AAHA/AAFP stage: kitten under one, young adult to six, mature
    /// adult seven to ten, senior over ten. "Over ten" is strict: a cat of
    /// ten years and one day is senior, a cat of exactly ten is not yet.
    static func stage(catYears years: Double) -> CatLifeStage {
        if years < 1 { return .kitten }
        if years < 7 { return .youngAdult }
        if years <= 10 { return .matureAdult }
        return .senior
    }
}
