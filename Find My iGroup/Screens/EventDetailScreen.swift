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
    
    @State private var paymentSheetIsShowing = false
    @State private var isLoading = true
    @State private var calendarDialogIsShowing = false
    @State private var successAlertIsShowing = false
    
    @ObservedObject var eventViewModel = EventViewModel()
    
    let store = EKEventStore.init()
    
    //    init () {
    //        store.req
    //    }
    
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
        if !isLoading {
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
                                VStack(alignment: .leading) {
                                    Text(eventViewModel.viewedEvent!.schedule.formatted(.dateTime.day().month().year().hour().minute()))
                                        .font(.subheadline)
                                    
                                    Text(eventViewModel.viewedEvent!.title)
                                        .font(.title)
                                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                        .padding(.bottom, -4)
                                    
                                    Text(eventViewModel.viewedEvent!.organization.capitalized(with: Locale(identifier: "id-ID")))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke()
                                        )
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    paymentSheetIsShowing.toggle()
                                }, label: {
                                    if eventViewModel.viewedEvent!.isJoined {
                                        Text("Joined")
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    } else {
                                        Text(eventViewModel.viewedEvent!.price, format: .currency(code: "IDR"))
                                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    }
                                })
                                .buttonStyle(BorderedProminentButtonStyle())
                                .fullScreenCover(isPresented: $paymentSheetIsShowing, onDismiss: {
                                    Task {
                                        try await eventViewModel.getEventById(eventId: id)
                                        isLoading = false
                                    }
                                }) {
                                    PaymentDetailsScreen(
                                        paymentAccountNumber: eventViewModel.viewedEvent!.paymentAccountNumber, paymentAccountName: eventViewModel.viewedEvent!.paymentAccountName, paymentAccountBank: eventViewModel.viewedEvent!.paymentAccountBank, price: eventViewModel.viewedEvent!.price, eventId: id, paymentProofImageUrl: eventViewModel.viewedEvent!.paymentProofImageUrl
                                    )
                                }
                                
                            }
                            
                        }
                        .padding(.all, 16)
                        .background(
                            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                                .opacity(1)
                        )
                    }
                    .frame(height: 274)
                    
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
                                
                                Image(systemName: "map")
                                    .foregroundStyle(.background)
                                    .padding(.all, 12)
                                    .background(
                                        Circle()
                                    )
                            }
                            Divider()
                            Link (destination: URL(string: eventViewModel.viewedEvent!.locationMapLink)!) {
                                Text("Visit maps")
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                        
                        
                        HStack(alignment: .center) {
                            Text("Estimated Fee")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(eventViewModel.viewedEvent!.price, format: .currency(code: "IDR") )
                        }
                        
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
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Documentation")
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Link(destination: URL(string: eventViewModel.viewedEvent!.documentationMainUrl)!) {
                                    Text("View all")
                                }
                            }
                            
                            TabView {
                                Image("badminton")
                                Image("badminton")
                                Image("badminton")
                            }
                            .tabViewStyle(.page)
                            .frame(height: 200)
                            .clipShape(.rect(cornerRadius: 8))
                        }
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
        } else {
            ProgressView()
                .progressViewStyle(.circular)
                .onAppear {
                    Task {
                        try await eventViewModel.getEventById(eventId: id)
                        isLoading = false
                    }
                }
        }
    }
}

//#Preview {
//    EventDetailScreen()
//}
