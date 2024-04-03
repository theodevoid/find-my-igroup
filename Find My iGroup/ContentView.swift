//
//  ContentView.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 19/03/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.currentUser != nil {
                TabView {
//                    NavigationStack {
//                        HomeScreen()
//                    }.tabItem {
//                        Label("Home", systemImage: "house.fill")
//                    }
                    
                    MyEventsScreen()
                        .tabItem {
                            Label("Events", systemImage: "calendar")
                        }
                    
                    ProfileScreen()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                    
                }
            } else {
                LoginScreen()
            }
        }.preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
            .tint(.orange)
        
        
        //        NavigationStack {
        //            DashboardList()
        //        }
    }
}

#Preview {
    ContentView()
}
