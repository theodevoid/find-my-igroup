//
//  EventDetailScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 26/03/24.
//

import SwiftUI
import EventKit

struct EventDetailScreen: View {
    var id: Int = 0
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @State private var confirmationDialogIsShowing = false
    @State private var isLoading = true
    @State private var calendarDialogIsShowing = false
    @State private var successAlertIsShowing = false
    
    @StateObject var eventViewModel = EventViewModel()
    
    let store = EKEventStore.init()
    
    func requestCalendarAccess() {
        store.requestWriteOnlyAccessToEvents(completion: {_,_ in
            print("ok")
        })
    }
    
    func addEventToCalendar() throws {
        requestCalendarAccess()
        
        let eventStore = EKEventStore()
        let event = EKEvent(eventStore: eventStore)
        let endDate = Date.init(timeInterval: 3600, since: eventViewModel.viewedEvent!.schedule)
        
        event.calendar = eventStore.defaultCalendarForNewEvents
        event.title = "[\(eventViewModel.viewedEvent!.organization.uppercased())] \(eventViewModel.viewedEvent!.title)"
        event.startDate = eventViewModel.viewedEvent!.schedule
        event.endDate = endDate
        
        do {
            try eventStore.save(event, span: .thisEvent)
        } catch {
            print(error)
        }
        
    }
    
    var body: some View {
        if !isLoading && eventViewModel.viewedEvent != nil {
            NavigationStack {
                ScrollView {
                    ZStack(alignment: .leading) {
                        Image(eventViewModel.viewedEvent!.organization.lowercased())
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0)
                        
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(eventViewModel.viewedEvent!.schedule.formatted(.dateTime.day().month().year().hour().minute()))
                                        .font(.subheadline)
                                    
                                    Text(eventViewModel.viewedEvent!.title)
                                        .font(.title)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .padding(.bottom, -4)
                                    HStack(alignment: .center) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "person.2.fill")
                                            Text("SIG " + eventViewModel.viewedEvent!.organization.capitalized(with: Locale(identifier: "id-ID")))
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                Spacer()
                            }
                            
                        }
                        .padding(.all, 16)
                        .background(
                            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                                .opacity(1)
                        )
                    }
                    .frame(height: 274)
                    .textCase(.uppercase)
                    .font(.caption)
                    
                    HStack(alignment: .center) {
                        Text("Total Rent Amount")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        Text(eventViewModel.viewedEvent!.totalPrice, format: .currency(code: "IDR") )
                            .bold()
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        VStack {
                            HStack(alignment: .center) {
                                VStack(alignment: .leading) {
                                    Text("Location")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    
                                    Text(eventViewModel.viewedEvent!.location)
                                        .fontWeight(.semibold)
                                    
                                    Text(eventViewModel.viewedEvent!.locationDetails)
                                        .font(.callout)
                                    
                                }
                                
                                Spacer()
                                
                                Link (destination: URL(string: eventViewModel.viewedEvent!.locationMapLink)!) {
                                    Image(systemName: "map")
                                        .foregroundStyle(.background)
                                        .padding(.all, 12)
                                        .background(
                                            Circle()
                                        )
                                }
                                
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                        
                        VStack(alignment: .leading) {
                            Text("Description")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            
                            Text(eventViewModel.viewedEvent!.description)
                                .lineLimit(3)
                        }
                        
                        Divider()
                        
                        NavigationLink (destination: MembersList(eventId: id)) {
                            HStack {
                                Text("Members Joined (\(eventViewModel.viewedEvent!.joinedCount!))")
                                    .foregroundStyle(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                        .foregroundStyle(.primary)
                    }
                    .padding(.horizontal, 16)
                }
                .ignoresSafeArea(.container, edges: .top)
                .preferredColorScheme(.dark)
                .refreshable {
                    Task {
                        try await eventViewModel.getEventById(eventId: id)
                    }
                }
                
                VStack {
                    VStack {
                        Button(action: {
                            confirmationDialogIsShowing = true
                        }, label: {
                            Text(eventViewModel.viewedEvent!.isJoined ? "Registered" : "Register")
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: 32)
                        })
                        .disabled(eventViewModel.viewedEvent!.isJoined)
                        .buttonStyle(BorderedProminentButtonStyle())
                        .tint(.orange)
                        .confirmationDialog("Register to event?", isPresented: $confirmationDialogIsShowing) {
                            Button("Register") {
                                Task {
                                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                                    impactMed.impactOccurred()
                                    
                                    try await eventViewModel.registerToEvent(eventId: id)
                                    
                                    dismiss.callAsFunction()
                                    
                                    try await Task.sleep(nanoseconds: 1000000000)
                                    
                                    viewRouter.currentView = 1
                                }
                            }
                            
                            Button("Cancel", role: .cancel) {}
                        }
                    }
                    .padding()
                    .padding(.bottom, 32)
                    .background(Color.black)
                    .frame(alignment: .bottom)
                }
                
            }
            .toolbar {
                Button(action: {
                    calendarDialogIsShowing = true
                }, label: {
                    Image(systemName: "bell.badge")
                })
                .foregroundStyle(.white)
                .alert("Added event to calendar", isPresented: $successAlertIsShowing) {
                    Button("OK", role: .cancel) {
                        
                    }
                }
                .confirmationDialog("Add event to calendar?", isPresented: $calendarDialogIsShowing, actions: {
                    Button("Add to calendar") {
                        do {
                            try addEventToCalendar()
                            successAlertIsShowing = true
                        } catch {
                            print("error")
                        }
                    }
                    
                })
                
            }
            .toolbar(.hidden, for: .tabBar)
            .ignoresSafeArea(.container, edges: .bottom)
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .onAppear {
                    Task {
                        try await eventViewModel.getEventById(eventId: id)
                        isLoading = false
                        
                        print(eventViewModel.viewedEvent)
                    }
                }
        }
    }
}

//#Preview {
//    EventDetailScreen()
//}
