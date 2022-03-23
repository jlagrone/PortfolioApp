//
//  ListingRow.swift
//  Unit Converter
//
//  Created by James LaGrone on 3/22/22.
//

import SwiftUI

struct ListingRow: View {
   var type: ConversionType

   var body: some View {
      NavigationLink(destination: ConversionView(type: type)) {
         Label(type.string, systemImage: type.imageName)
            .foregroundColor(Color.accentColor)
            .accessibilityHint("Tap to convert \(type.string)")
      }
   }
}

struct ListingRow_Previews: PreviewProvider {
   static var previews: some View {
      ListingRow(type: ConversionType.energy)
   }
}



