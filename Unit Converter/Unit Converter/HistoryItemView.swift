//
//  HistoryItemView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import SwiftUI

struct HistoryItemView: View {

    var conversionItem: Conversion

    var mainText: String {
        "\(conversionItem.conversionInputAsString) to \(String(describing: conversionItem.conversionResultAsString))"
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
    }
}

//struct HistoryItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        HistoryItemView()
//    }
//}
