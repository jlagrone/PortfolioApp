//
//  ListingGridItem.swift
//  Unit Converter
//
//  Created by James LaGrone on 3/22/22.
//

import SwiftUI

struct ListingGridItem: View {
   var type: ConversionType

   var body: some View {
      NavigationLink(destination: ConversionView(type: type)) {
         VStack {
            Image(systemName: type.imageName)
               .font(.largeTitle)
            Text(type.string)
               .font(.caption2)
         }
         .fixedSize()
         .foregroundColor(Color.accentColor)
         .accessibilityHint("Tap to convert \(type.string)")
         .padding()
      }
      .background(Color.secondarySystemGroupedBackground)
      .cornerRadius(10)
      .shadow(color: Color.black.opacity(0.2), radius: 5)
   }
}

struct ListingGridItem_Previews: PreviewProvider {
   static var previews: some View {
      ListingGridItem(type: ConversionType.mass)
//      ListingGridItem(type: ConversionType.length)
   }
}
