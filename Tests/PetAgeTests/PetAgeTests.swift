//
//  PetAgeTests.swift
//  PetAge
//
//  Every test is a fixed age with one right answer off a published chart or
//  guideline, cited where it comes from.
//

import XCTest
@testable import PetAge

final class DogChartTests: XCTestCase {

    /// The size-adjusted chart as published (15, 24, then +4/+5/+6/+7 a year),
    /// every row for one to eighteen years, small/medium/large/giant.
    private let chart: [(Double, [Double])] = [
        (1, [15, 15, 15, 15]), (2, [24, 24, 24, 24]), (3, [28, 29, 30, 31]), (4, [32, 34, 36, 38]),
        (5, [36, 39, 42, 45]), (6, [40, 44, 48, 52]), (7, [44, 49, 54, 59]), (8, [48, 54, 60, 66]),
        (9, [52, 59, 66, 73]), (10, [56, 64, 72, 80]), (11, [60, 69, 78, 87]), (12, [64, 74, 84, 94]),
        (13, [68, 79, 90, 101]), (14, [72, 84, 96, 108]), (15, [76, 89, 102, 115]), (16, [80, 94, 108, 122]),
        (17, [84, 99, 114, 129]), (18, [88, 104, 120, 136]),
    ]

    func testEveryRowOfThePublishedChart() throws {
        for (dogYears, row) in chart {
            for (size, expected) in zip(DogSize.allCases, row) {
                XCTAssertEqual(try PetAge.humanYears(dogYears: dogYears, size: size), expected, "\(size) at \(dogYears)")
            }
        }
    }

    func testTheFirstTwoYearsAreTheSameForEverySize() throws {
        for size in DogSize.allCases {
            XCTAssertEqual(try PetAge.humanYears(dogYears: 0, size: size), 0)
            XCTAssertEqual(try PetAge.humanYears(dogYears: 0.5, size: size), 7.5)
            XCTAssertEqual(try PetAge.humanYears(dogYears: 1, size: size), 15)
            XCTAssertEqual(try PetAge.humanYears(dogYears: 1.5, size: size), 19.5)
            XCTAssertEqual(try PetAge.humanYears(dogYears: 2, size: size), 24)
        }
    }

    func testMonthsCountAtTheSizesRate() throws {
        // Two and a half: half a year past two is half the increment.
        XCTAssertEqual(try PetAge.humanYears(dogYears: 2.5, size: .small), 26)
        XCTAssertEqual(try PetAge.humanYears(dogYears: 2.5, size: .giant), 27.5)
        XCTAssertEqual(try PetAge.humanYears(dogYears: 10.25, size: .medium), 65.25)
    }

    func testTheDefaultSizeIsMediumTheAVMABaseline() throws {
        XCTAssertEqual(try PetAge.humanYears(dogYears: 5), 39)
    }

    func testTheChartRunsBackwards() throws {
        for (dogYears, row) in chart {
            for (size, human) in zip(DogSize.allCases, row) {
                XCTAssertEqual(try PetAge.dogYears(forHumanYears: human, size: size), dogYears, accuracy: 1e-9, "\(size) at \(human)")
            }
        }
        XCTAssertEqual(try PetAge.dogYears(forHumanYears: 0, size: .small), 0)
        XCTAssertEqual(try PetAge.dogYears(forHumanYears: 7.5, size: .large), 0.5)
        XCTAssertEqual(try PetAge.dogYears(forHumanYears: 19.5, size: .giant), 1.5)
        XCTAssertEqual(try PetAge.dogYears(forHumanYears: 26, size: .small), 2.5)
    }

    func testTheInverseRoundTripsAtArbitraryAges() throws {
        for size in DogSize.allCases {
            for years in stride(from: 0.0, through: 20.0, by: 0.37) {
                let human = try PetAge.humanYears(dogYears: years, size: size)
                XCTAssertEqual(try PetAge.dogYears(forHumanYears: human, size: size), years, accuracy: 1e-9)
            }
        }
    }
}

final class EpigeneticTests: XCTestCase {

    func testTheFormulaAtItsPublishedPoints() throws {
        // 16 · ln(age) + 31, Wang et al. 2020: one-year-old 31, sixteen 75.4.
        XCTAssertEqual(try PetAge.humanYears(dogYears: 1, method: .epigenetic), 31, accuracy: 1e-9)
        XCTAssertEqual(try PetAge.humanYears(dogYears: 4, method: .epigenetic), 16 * log(4) + 31, accuracy: 1e-9)
        XCTAssertEqual(try PetAge.humanYears(dogYears: 16, method: .epigenetic), 75.36, accuracy: 0.01)
    }

    func testSizeDoesNotEnterTheFormula() throws {
        for size in DogSize.allCases {
            XCTAssertEqual(try PetAge.humanYears(dogYears: 7, size: size, method: .epigenetic), 16 * log(7) + 31, accuracy: 1e-9)
        }
    }

    func testTheCurveIsFlooredAtZeroBelowSevenWeeks() throws {
        // ln goes negative fast: at 0.1 years the raw formula says -5.8.
        XCTAssertEqual(try PetAge.humanYears(dogYears: 0.1, method: .epigenetic), 0)
        XCTAssertEqual(try PetAge.humanYears(dogYears: 0, method: .epigenetic), 0)
        // exp(-31/16) ≈ 0.144 years is where it crosses zero.
        XCTAssertEqual(try PetAge.humanYears(dogYears: exp(-31.0 / 16), method: .epigenetic), 0, accuracy: 1e-9)
        XCTAssertGreaterThan(try PetAge.humanYears(dogYears: 0.15, method: .epigenetic), 0)
    }

    func testItIsFrontLoadedAgainstTheChart() throws {
        // Older than the chart says early on, younger later — the shape the study describes.
        XCTAssertGreaterThan(try PetAge.humanYears(dogYears: 1, method: .epigenetic), try PetAge.humanYears(dogYears: 1))
        XCTAssertLessThan(try PetAge.humanYears(dogYears: 16, method: .epigenetic), try PetAge.humanYears(dogYears: 16))
    }
}

final class DogStageTests: XCTestCase {

    func testPuppyEndsAtNineMonths() throws {
        XCTAssertEqual(try PetAge.stage(dogYears: 0), .puppy)
        XCTAssertEqual(try PetAge.stage(dogYears: 0.74), .puppy)
        XCTAssertEqual(try PetAge.stage(dogYears: 0.75), .youngAdult)
    }

    func testYoungAdultEndsAtThreeAndAHalf() throws {
        XCTAssertEqual(try PetAge.stage(dogYears: 3.49), .youngAdult)
        XCTAssertEqual(try PetAge.stage(dogYears: 3.5), .matureAdult)
    }

    func testSeniorIsTheLastQuarterOfTheLifespanBySize() throws {
        // Typical lifespans 14, 12, 10, 8 → senior from 10.5, 9, 7.5, 6.
        XCTAssertEqual(try PetAge.stage(dogYears: 10.49, size: .small), .matureAdult)
        XCTAssertEqual(try PetAge.stage(dogYears: 10.5, size: .small), .senior)
        XCTAssertEqual(try PetAge.stage(dogYears: 8.99, size: .medium), .matureAdult)
        XCTAssertEqual(try PetAge.stage(dogYears: 9, size: .medium), .senior)
        XCTAssertEqual(try PetAge.stage(dogYears: 7.49, size: .large), .matureAdult)
        XCTAssertEqual(try PetAge.stage(dogYears: 7.5, size: .large), .senior)
        XCTAssertEqual(try PetAge.stage(dogYears: 5.99, size: .giant), .matureAdult)
        XCTAssertEqual(try PetAge.stage(dogYears: 6, size: .giant), .senior)
    }

    func testABreedYouKnowOverridesTheTypicalLifespan() throws {
        // A 16-year breed is senior from 12; a 4-year lifespan makes the
        // senior boundary fall inside young adulthood, and young adult wins.
        XCTAssertEqual(try PetAge.stage(dogYears: 11, size: .small, lifespanYears: 16), .matureAdult)
        XCTAssertEqual(try PetAge.stage(dogYears: 12, size: .small, lifespanYears: 16), .senior)
        XCTAssertEqual(try PetAge.stage(dogYears: 3.4, lifespanYears: 4), .youngAdult)
        XCTAssertEqual(try PetAge.stage(dogYears: 3.5, lifespanYears: 4), .senior)
    }

    func testABadLifespanIsRefused() {
        XCTAssertThrowsError(try PetAge.stage(dogYears: 3, lifespanYears: 0))
        XCTAssertThrowsError(try PetAge.stage(dogYears: 3, lifespanYears: -12)) { error in
            XCTAssertEqual(error as? PetAgeError, .badAge(-12))
        }
        XCTAssertThrowsError(try PetAge.stage(dogYears: 3, lifespanYears: .infinity))
    }

    func testTheStagesHaveWords() {
        XCTAssertEqual(DogLifeStage.puppy.label, "Puppy")
        XCTAssertEqual(DogLifeStage.youngAdult.label, "Young adult")
        XCTAssertEqual(DogLifeStage.matureAdult.label, "Mature adult")
        XCTAssertEqual(DogLifeStage.senior.label, "Senior")
        XCTAssertEqual(DogLifeStage.allCases.count, 4)
    }
}

final class CatTests: XCTestCase {

    func testTheFelineConversion() throws {
        // 15, 24, then four a year — a ten-year-old cat is 56.
        XCTAssertEqual(try PetAge.humanYears(catYears: 0), 0)
        XCTAssertEqual(try PetAge.humanYears(catYears: 0.5), 7.5)
        XCTAssertEqual(try PetAge.humanYears(catYears: 1), 15)
        XCTAssertEqual(try PetAge.humanYears(catYears: 2), 24)
        XCTAssertEqual(try PetAge.humanYears(catYears: 3), 28)
        XCTAssertEqual(try PetAge.humanYears(catYears: 10), 56)
        XCTAssertEqual(try PetAge.humanYears(catYears: 15), 76)
        XCTAssertEqual(try PetAge.humanYears(catYears: 20), 96)
        XCTAssertEqual(try PetAge.humanYears(catYears: 2.25), 25)
    }

    func testTheFelineConversionRunsBackwards() throws {
        XCTAssertEqual(try PetAge.catYears(forHumanYears: 0), 0)
        XCTAssertEqual(try PetAge.catYears(forHumanYears: 7.5), 0.5)
        XCTAssertEqual(try PetAge.catYears(forHumanYears: 15), 1)
        XCTAssertEqual(try PetAge.catYears(forHumanYears: 24), 2)
        XCTAssertEqual(try PetAge.catYears(forHumanYears: 56), 10)
        for years in stride(from: 0.0, through: 25.0, by: 0.41) {
            XCTAssertEqual(try PetAge.catYears(forHumanYears: try PetAge.humanYears(catYears: years)), years, accuracy: 1e-9)
        }
    }

    func testTheFelineStagesAtTheirBoundaries() throws {
        // AAHA/AAFP 2021: kitten to one, young adult one to six, mature adult
        // seven to ten, senior over ten.
        XCTAssertEqual(try PetAge.stage(catYears: 0), .kitten)
        XCTAssertEqual(try PetAge.stage(catYears: 0.99), .kitten)
        XCTAssertEqual(try PetAge.stage(catYears: 1), .youngAdult)
        XCTAssertEqual(try PetAge.stage(catYears: 6.99), .youngAdult)
        XCTAssertEqual(try PetAge.stage(catYears: 7), .matureAdult)
        XCTAssertEqual(try PetAge.stage(catYears: 10), .matureAdult)
        XCTAssertEqual(try PetAge.stage(catYears: 10.01), .senior)
        XCTAssertEqual(try PetAge.stage(catYears: 25), .senior)
    }

    func testTheFelineStagesHaveWords() {
        XCTAssertEqual(CatLifeStage.kitten.label, "Kitten")
        XCTAssertEqual(CatLifeStage.matureAdult.label, "Mature adult")
        XCTAssertEqual(CatLifeStage.allCases.count, 4)
    }
}

final class SizeTests: XCTestCase {

    func testWeightBandsInPounds() {
        XCTAssertEqual(DogSize(weightPounds: 0), .small)
        XCTAssertEqual(DogSize(weightPounds: 19.9), .small)
        XCTAssertEqual(DogSize(weightPounds: 20), .medium)
        XCTAssertEqual(DogSize(weightPounds: 49.9), .medium)
        XCTAssertEqual(DogSize(weightPounds: 50), .large)
        XCTAssertEqual(DogSize(weightPounds: 90), .large)
        XCTAssertEqual(DogSize(weightPounds: 90.1), .giant)
        XCTAssertEqual(DogSize(weightPounds: 200), .giant)
    }

    func testWeightBandsInKilograms() {
        // 20 lb is 9.07 kg; 90 lb is 40.8 kg.
        XCTAssertEqual(DogSize(weightKilograms: 9), .small)
        XCTAssertEqual(DogSize(weightKilograms: 9.1), .medium)
        XCTAssertEqual(DogSize(weightKilograms: 22.7), .large)
        XCTAssertEqual(DogSize(weightKilograms: 40.8), .large)
        XCTAssertEqual(DogSize(weightKilograms: 41), .giant)
        XCTAssertEqual(SizeClassification.pounds(fromKilograms: 1), 2.20462)
    }

    func testEachSizeCarriesItsFigures() {
        XCTAssertEqual(DogSize.allCases.map(\.annualIncrement), [4, 5, 6, 7])
        XCTAssertEqual(DogSize.allCases.map(\.typicalLifespanYears), [14, 12, 10, 8])
        XCTAssertEqual(DogSize.small.weightRange, "under 20 lb")
        XCTAssertEqual(DogSize.medium.weightRange, "20–50 lb")
        XCTAssertEqual(DogSize.large.weightRange, "50–90 lb")
        XCTAssertEqual(DogSize.giant.weightRange, "over 90 lb")
    }
}

final class AgeAndConversionTests: XCTestCase {

    func testAnAgeInYearsAndMonths() throws {
        XCTAssertEqual(try Age(years: 1, months: 6).totalYears, 1.5)
        XCTAssertEqual(try Age(years: 0).totalYears, 0)
        XCTAssertEqual(try Age(years: 0, months: 11).totalYears, 11.0 / 12, accuracy: 1e-12)
        XCTAssertEqual(try Age(years: 12, months: 0).totalYears, 12)
    }

    func testABadAgeIsRefused() {
        XCTAssertThrowsError(try Age(years: 1, months: 12)) { error in
            XCTAssertEqual(error as? PetAgeError, .badMonths(12))
            XCTAssertTrue(error.localizedDescription.contains("twelve months is another year"))
        }
        XCTAssertThrowsError(try Age(years: 1, months: -1))
        XCTAssertThrowsError(try Age(years: -1)) { error in
            XCTAssertEqual(error as? PetAgeError, .badAge(-1))
            XCTAssertTrue(error.localizedDescription.contains("zero or more"))
        }
        XCTAssertThrowsError(try PetAge.humanYears(dogYears: -0.5))
        XCTAssertThrowsError(try PetAge.humanYears(catYears: .nan))
        XCTAssertThrowsError(try PetAge.humanYears(dogYears: .infinity))
        XCTAssertThrowsError(try PetAge.dogYears(forHumanYears: -1))
        XCTAssertThrowsError(try PetAge.catYears(forHumanYears: -1))
        XCTAssertThrowsError(try PetAge.stage(dogYears: -1))
        XCTAssertThrowsError(try PetAge.stage(catYears: -1))
    }

    func testAWholeConversionForADog() throws {
        let dog = try PetAge.convert(try Age(years: 7, months: 6), of: .dog, size: .large)
        XCTAssertEqual(dog.species, .dog)
        XCTAssertEqual(dog.petYears, 7.5)
        XCTAssertEqual(dog.humanYears, 57)
        XCTAssertEqual(dog.stage, "senior")
        XCTAssertEqual(dog.size, .large)
        XCTAssertEqual(dog.method, .sizeAdjusted)

        let clock = try PetAge.convert(try Age(years: 4), of: .dog, method: .epigenetic)
        XCTAssertEqual(clock.humanYears, 16 * log(4) + 31, accuracy: 1e-9)
        XCTAssertEqual(clock.method, .epigenetic)
        XCTAssertEqual(clock.stage, "matureAdult")

        let longLived = try PetAge.convert(try Age(years: 9), of: .dog, size: .medium, lifespanYears: 16)
        XCTAssertEqual(longLived.stage, "matureAdult")
    }

    func testAWholeConversionForACat() throws {
        let cat = try PetAge.convert(try Age(years: 10, months: 1), of: .cat, size: .giant, method: .epigenetic)
        XCTAssertEqual(cat.species, .cat)
        XCTAssertEqual(cat.humanYears, 56 + 4.0 / 12, accuracy: 1e-9)
        XCTAssertEqual(cat.stage, "senior")
        XCTAssertNil(cat.size, "size means nothing for a cat, whatever was passed")
        XCTAssertNil(cat.method)
    }

    func testEverythingRoundTripsThroughJSON() throws {
        let age = try Age(years: 3, months: 4)
        XCTAssertEqual(try JSONDecoder().decode(Age.self, from: JSONEncoder().encode(age)), age)
        let conversion = try PetAge.convert(age, of: .dog, size: .giant)
        XCTAssertEqual(try JSONDecoder().decode(Conversion.self, from: JSONEncoder().encode(conversion)), conversion)
        for species in Species.allCases {
            XCTAssertEqual(try JSONDecoder().decode(Species.self, from: JSONEncoder().encode(species)), species)
        }
        for size in DogSize.allCases {
            XCTAssertEqual(try JSONDecoder().decode(DogSize.self, from: JSONEncoder().encode(size)), size)
        }
        for method in DogMethod.allCases {
            XCTAssertEqual(try JSONDecoder().decode(DogMethod.self, from: JSONEncoder().encode(method)), method)
        }
        for stage in DogLifeStage.allCases {
            XCTAssertEqual(try JSONDecoder().decode(DogLifeStage.self, from: JSONEncoder().encode(stage)), stage)
        }
        for stage in CatLifeStage.allCases {
            XCTAssertEqual(try JSONDecoder().decode(CatLifeStage.self, from: JSONEncoder().encode(stage)), stage)
        }
    }

    func testTheLabelArithmetic() {
        XCTAssertEqual(LifeStageLabels.label(for: "youngAdult"), "Young adult")
        XCTAssertEqual(LifeStageLabels.label(for: "senior"), "Senior")
        XCTAssertEqual(LifeStageLabels.label(for: ""), "")
    }
}
