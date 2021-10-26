//
//  HistoryItemView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import SwiftUI

struct HistoryItemView: View {

    var conversionItem: Conversion

    let TO_STRING = NSLocalizedString("to", comment: "'to' in History Item View")
    var mainText: String {
        return "\(conversionItem.conversionInputAsString) \(TO_STRING) \(String(describing: conversionItem.conversionResultAsString))"
    }

    private var accessibilityLabelText: String {
        "Converted \(conversionItem.conversionInputAsString) \(TO_STRING) \(String(describing: conversionItem.conversionResultAsString)), \(conversionItem.conversionDate.shortDescription)"
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(conversionItem.conversionTypeString)
                .font(.headline)
                .foregroundColor(Color.accentColor)
            Text(mainText).padding(.leading, 12.0)
            HStack {
                Spacer()
                Text("\(conversionItem.conversionDate.shortDescription)")
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabelText)
    }
}

//struct HistoryItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryItemView()
//    }
//}
