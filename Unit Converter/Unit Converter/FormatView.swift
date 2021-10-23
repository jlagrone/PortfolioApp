//
//  FormatView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/19/20.
//

import SwiftUI

struct FormatView: View {

    @Binding var format: OutputFormat
    @Binding var significantDigits: Double
    @Binding var fractionPrecision: Double

    var lowerLimitDecimals = 0.0
    var lowerLimitSignificant = 1.0
    var upperLimit = 10.0

    let DIGITS_STRING = NSLocalizedString("digits after decimal", comment: "in Format View: 'digits after decimal'")

    var body: some View {
        if format == .decimalPlaces {
            return AnyView (
                VStack{
                    HStack {
                        Text("\(Int(lowerLimitDecimals))").font(.caption)

                        Slider(value: $fractionPrecision,
                               in: lowerLimitDecimals...upperLimit,
                               step: 1.0)

                        Text("\(Int(upperLimit))").font(.caption)
                    }
                    Text("\(Int(fractionPrecision)) \(DIGITS_STRING)")
                        .font(.caption)
                }
            )
        } else {
            return AnyView (
                VStack{
                    HStack {
                        Text("\(Int(lowerLimitSignificant))").font(.caption)

                        Slider(value: $significantDigits,
                               in: lowerLimitSignificant...upperLimit,
                               step: 1.0)

                        Text("\(Int(upperLimit))").font(.caption)
                    }
                    Text("\(Int(significantDigits)) significant digit")
                        .font(.caption)
                }
            )
        }
    }
}

struct FormatView_Previews: PreviewProvider {

    static var previews: some View {
        FormatView(format: .constant(OutputFormat.decimalPlaces),
                   significantDigits: .constant(3.0),
                   fractionPrecision: .constant(3.0))
    }
}
