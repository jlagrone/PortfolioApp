//
//  ContentView.swift
//  Shared
//
//  Created by James LaGrone on 10/9/20.
//

import SwiftUI
import Foundation




struct ConversionSelectionListView: View {
    @EnvironmentObject var dataController: DataController

    static let tag: String? = "ConversionSelectionListView"

    let accentColor = Color.accentColor

    @State var showingSettings: Bool = false

    var body: some View {
        ZStack {
            NavigationView {
                List(ConversionType.allCases, id: \.self) { type in
                    NavigationLink(destination: ConversionView(type: type)) {
                        Label(type.string, systemImage: type.imageName)
                            .foregroundColor(accentColor)
                    }
                }
                .navigationTitle("Unit Converter")
                .navigationBarItems(
                    // for early dev and testing
//                    leading:  Button(action: addSampleData ) { Image(systemName: "plus")},
                    trailing: Button(action: { showingSettings.toggle()
                }) { Image(systemName: "gearshape") })
            }
            .accentColor(accentColor)
            .foregroundColor(accentColor)
        }
        .sheet(isPresented: $showingSettings, content: {
            SettingsView()
        })
    }

//    // for early dev and testing
//    private func addSampleData() {
//            dataController.deleteAll()
//            try? dataController.createSampleData()
//    }

}



struct ConversionSelectionListView_Previews: PreviewProvider {

    static var previews: some View {
        ConversionSelectionListView()
    }
}

