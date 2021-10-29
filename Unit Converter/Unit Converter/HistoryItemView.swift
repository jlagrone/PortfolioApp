//
//  HistoryItemView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import SwiftUI

struct HistoryItemView: View {

    var conversionItem: Conversion

    // swiftlint:disable identifier_name
    private let TO_STRING = NSLocalizedString("to", comment: "'to' in History Item View")
    private var inputString: String { conversionItem.conversionInputAsString }
    private var resultString: String { String(describing: conversionItem.conversionResultAsString) }
    private var dateString: String { conversionItem.conversionDate.shortDescription }

    var mainText: String {
        return "\(inputString) \(TO_STRING) \(resultString)"
    }

    private var accessibilityLabelText: String {
        return "Converted \(inputString) \(TO_STRING) \(resultString), \(dateString)"
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(conversionItem.conversionTypeString)
                .font(.headline)
                .foregroundColor(Color.accentColor)
            Text(mainText).padding(.leading, 12.0)
            HStack {
                Spacer()
                Text("\(dateString)")
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabelText)
    }
}

// struct HistoryItemView_Previews: PreviewProvider {
//    static var previews: some View {
//       HistoryItemView(conversionItem: Conversion.sample)
//    }
// }
