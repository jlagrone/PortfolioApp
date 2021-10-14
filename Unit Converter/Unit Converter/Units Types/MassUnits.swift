//
//  MassUnits.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/20.
//

import Foundation

struct MassUnits: UnitProtocol {

    static var imageName: String { "scalemass" }

    static let metric: [UnitMass] = [.kilograms, .grams, .decigrams, .centigrams, .milligrams,
                                     .micrograms, .nanograms, .picograms, .metricTons]

    static let imperial: [UnitMass] = [.ounces, .pounds, .stones, .slugs, .shortTons]

    static let other: [UnitMass] = [.carats, .ouncesTroy]

    static var all: [UnitMass] {
        if usesImperial {
            return imperial + metric + other
        } else {
            return metric + imperial + other
        }

    }
}
