//
//  HomeView.swift
//  Unit Converter
//
//  Created by James LaGrone on 10/14/21.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        NavigationView {
            VStack {
                Button("Add to history") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
