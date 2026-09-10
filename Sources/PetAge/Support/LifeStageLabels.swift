//
//  LifeStageLabels.swift
//  PetAge
//

import Foundation

/// Raw stage names to the words people use.
enum LifeStageLabels {

    /// `youngAdult` becomes `Young adult`; single words are capitalised.
    static func label(for rawValue: String) -> String {
        var words = ""
        for character in rawValue {
            if character.isUppercase { words += " " + character.lowercased() } else { words.append(character) }
        }
        return words.prefix(1).uppercased() + words.dropFirst()
    }
}
