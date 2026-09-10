//
//  DogLifeStage.swift
//  PetAge
//

import Foundation

/// The 2019 AAHA Canine Life Stage Guidelines' four stages of a living dog.
///
/// The guidelines define the last two by the animal's expected lifespan, not
/// by a fixed age: mature adult runs to the start of the last 25% of life,
/// and senior is that last quarter. That is why a Great Dane is senior at
/// six and a Chihuahua at ten and a half.
public enum DogLifeStage: String, CaseIterable, Sendable, Codable {

    /// Birth to the end of rapid growth, which the guidelines put at 6–9 months.
    case puppy

    /// To the completion of physical and social maturation, at 3–4 years.
    case youngAdult

    /// To the beginning of the last 25% of the expected lifespan.
    case matureAdult

    /// The last quarter of the expected lifespan.
    case senior

    /// The stage as people say it: `Young adult`.
    public var label: String { LifeStageLabels.label(for: rawValue) }
}
