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
                Picker("", selection: $selectedScreen) {
                    Text("Upcoming Events").tag(0)
                    
                    Text("Past Events").tag(1)
                }
                .pickerStyle(.automatic)
                
                ForEach(selectedScreen == 0 ? eventViewModel.myUpcomingEvents : eventViewModel.myPastEvents) { event in
                    ZStack {
                        EventListItem(organization: event.organization, title: event.title, schedule: event.schedule)
                        NavigationLink(destination: EventDetailScreen(id: event.id)) {
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(0)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .listRowSpacing(8)
            .navigationTitle("My Events")
            .refreshable {
                Task {
                    try await eventViewModel.getMyPastEvents()
                    try await eventViewModel.getMyUpcomingEvents()
                }
            }
            .onAppear {
                Task {
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
