//
//  ContentView.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 19/03/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel : AuthViewModel
    @EnvironmentObject var viewRouter: ViewRouter
//    @StateObject var eventViewModel: EventViewModel
    
    @State var selectedTab = 0
    
    var body: some View {
        Group {
            if viewModel.currentUser != nil {
                TabView(selection: $viewRouter.currentView) {
                    MyEventsScreen()
                        .tabItem {
                            Label("Events", systemImage: "calendar")
                        }
                        .tag(0)
                    
                    RegistrationsScreen()
                        .tabItem {
                            Label("Registrations", systemImage: "tray")
                        }
                        .tag(1)
                    
                    ProfileScreen()
                        .tabItem {
                            Label("Profile", systemImage: "person.fill")
                        }
                        .tag(2)
                    
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

//#Preview {
////    ContentView()
//}
