//
//  SettingsButton.swift
//  Unit Converter
//
//  Created by James LaGrone on 3/22/22.
//

import SwiftUI

struct SettingsButton: View {

   @Binding var showingSettings: Bool

   // The Settings Button for the tool bar
   var body: some View {
      Button {
         showingSettings.toggle()
      } label: {
         Image(systemName: "gearshape")
      }
      .accessibilityLabel("Open Settings")
      .sheet(isPresented: $showingSettings, onDismiss: onDismiss) {
         SettingsView()
      }
   }

   func onDismiss() {
      print("Dismissing")
   }
}
struct SettingsButton_Previews: PreviewProvider {
    static var previews: some View {
       SettingsButton(showingSettings: Binding.constant(false))
    }
}
