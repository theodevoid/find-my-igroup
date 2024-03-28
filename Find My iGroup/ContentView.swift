//
//  ContentView.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 19/03/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                LoginScreen()
            }
            
//            Group {
//                NavigationStack {
//                    HomeScreen()
//                }.tabItem {
//                    Label("Home", systemImage: "house.fill")
//                }
//
//                MyEventsScreen()
//                    .tabItem {
//                        Label("Home", systemImage: "calendar")
//                    }
//                
//                ProfileScreen()
//                    .tabItem {
//                        Label("Home", systemImage: "person.fill")
//                    }
//            }
        }
        .preferredColorScheme(.dark)

//        NavigationStack {
//            DashboardList()
//        }
    }
}

#Preview {
    ContentView()
}
