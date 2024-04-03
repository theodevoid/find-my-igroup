//
//  MyEventsScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import SwiftUI

struct MyEventsScreen: View {
    @State private var selectedScreen = 0
    
    @ObservedObject var eventViewModel = EventViewModel()
    
    var body: some View {
        
        NavigationStack {
            List  {
                Picker("Select Events", selection: $selectedScreen) {
                    Text("Upcoming").tag(0)
                    Text("Joined Upcoming").tag(1)
                    Text("Joined Past").tag(2)
                }
                .pickerStyle(.automatic)
                
                ForEach(selectedScreen == 0 ? eventViewModel.upcomingEvents : selectedScreen == 1 ? eventViewModel.myUpcomingEvents : eventViewModel.myPastEvents) { event in
                    ZStack {
                        EventListItem(organization: event.organization, title: event.title, schedule: event.schedule, price: event.price, isJoined: event.isJoined)
                        NavigationLink(destination: EventDetailScreen(id: event.id)) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(0)
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.insetGrouped)
            .listRowSpacing(8)
            .navigationTitle("Events")
            .refreshable {
                Task {
                    try await eventViewModel.getUpcomingEvents()
                    try await eventViewModel.getMyPastEvents()
                    try await eventViewModel.getMyUpcomingEvents()
                }
            }
            .onAppear {
                Task {
                    try await eventViewModel.getUpcomingEvents()
                    try await eventViewModel.getMyPastEvents()
                    try await eventViewModel.getMyUpcomingEvents()
                }
            }
        }
    }
}

#Preview {
    MyEventsScreen()
}
