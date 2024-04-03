//
//  HomeScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import SwiftUI

struct HomeScreen: View {
    @State private var selectedFilter = 0
    
    @State private var upcomingEvents: [Event] = []
    
    @ObservedObject var homeViewModel = EventViewModel()
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        self.sendDeviceTokenToServer(data: deviceToken)
        print(deviceToken)
        print("OYOYOOYOYOYOYO")
    }
    
    var body: some View {
        ZStack {
            List($upcomingEvents, id: \.id) { event in
                ZStack {
                    EventListItem(organization: event.wrappedValue.organization, title: event.wrappedValue.title, schedule: event.wrappedValue.schedule, price: event.wrappedValue.price, isJoined: event.wrappedValue.isJoined)
                    NavigationLink(destination: EventDetailScreen(id: event.wrappedValue.id)) {
                        EmptyView()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(0)
                }
                .listRowInsets(EdgeInsets())
            }
            .listStyle(.insetGrouped)
            .listRowSpacing(8)
            .navigationTitle("Upcoming")
            .onAppear {
                Task {
                    let fetchedEvents = try await homeViewModel.getUpcomingEvents()
                    
                    await MainActor.run {
                        upcomingEvents = fetchedEvents
                    }
                }
            }
            .refreshable {
                Task {
                    let fetchedEvents = try await homeViewModel.getUpcomingEvents()
                    
                    await MainActor.run {
                        upcomingEvents = fetchedEvents
                    }
                }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
