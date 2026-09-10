//
//  CatLifeStage.swift
//  PetAge
//

import Foundation

/// The 2021 AAHA/AAFP Feline Life Stage Guidelines' four stages of a living cat.
public enum CatLifeStage: String, CaseIterable, Sendable, Codable {

    /// Birth up to one year.
    case kitten

    /// One year through six.
    case youngAdult

    /// Seven through ten.
    case matureAdult

    /// Over ten.
    case senior

    /// The stage as people say it: `Mature adult`.
    public var label: String { LifeStageLabels.label(for: rawValue) }
}
