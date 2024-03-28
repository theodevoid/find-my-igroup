//
//  HomeScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selectedFilter = 0
    
    var body: some View {
        ZStack {
            List {
                Picker("", selection: $selectedFilter) {
                    Text("Upcoming Events").tag(0)
                    Text("Past Events").tag(1)
                }
                .pickerStyle(.automatic)
                
                EventListItem()
                EventListItem()
                EventListItem()
            }
            .background(
//                LinearGradient(gradient: Gradient(colors: [.orange, .primary]), startPoint: .topLeading, endPoint: .bottom)
            )
            .listStyle(.insetGrouped)
            .listRowSpacing(8)
            .navigationTitle("Home")
//            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    HomeScreen()
}
