//
//  RegistrationDetailScreen.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 03/04/24.
//

import SwiftUI

struct RegistrationDetailScreen: View {
    var id: Int
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var eventViewModel = EventViewModel()
    
    @State private var paymentSheetIsShowing = false
    @State private var successSheetIsShowing = false
    @State private var isLoading = true
    
    var body: some View {
        if !isLoading && eventViewModel.viewedEvent != nil {
            VStack {
                List {
                    Section(header: ZStack(alignment: .leading) {
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
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    HStack(alignment: .center) {
                                        HStack(spacing: 8) {
                                            Image(systemName: "person.2.fill")
                                            Text("SIG " + eventViewModel.viewedEvent!.organization.capitalized(with: Locale(identifier: "id-ID")))
                                        }
                                        
                                        Spacer()
                                        
                                        if eventViewModel.viewedEvent!.paymentProofImageUrl == nil {
                                            Text("Not Paid")
                                                .bold()
                                                .padding(.horizontal, 8)
                                                .background(Color.red)
                                                .clipShape(Capsule())
                                        } else {
                                            Text("Paid")
                                                .bold()
                                                .padding(.horizontal, 8)
                                                .background(Color.green)
                                                .clipShape(Capsule())
                                        }
                                    }
                                }
                                Spacer()
                            }
                            
                        }
                        .padding(.all, 24)
                        .background(
                            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
                                .opacity(1)
                        )
                    }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .frame(height: 274)
                        .padding(.horizontal, -24)
                        .foregroundStyle(.primary)
                    ) {
                            
                        }
                    
                    NavigationLink(destination: EventDetailScreen(id: id)) {
                        Button {
                            
                        } label: {
                            Text("Visit Event Details")
                        }
                    }
                    
                    Section(header: Text("Pricing Information")) {
                        HStack {
                            Text("Total Rent Amount")
                                .foregroundStyle(.secondary)
                            
                            Spacer()
                            
                            Text(eventViewModel.viewedEvent!.totalPrice, format: .currency(code: "IDR"))
                        }
                        
                        NavigationLink(destination: MembersList(eventId: id)) {
                            HStack {
                                Text("Joined Members")
                                    .foregroundStyle(.secondary)
                                
                                Spacer()
                                
                                Text(String(eventViewModel.viewedEvent!.joinedCount ?? 0))
                            }
                        }
                        
                        
                        HStack {
                            Text("Est. Price per Person")
                                .foregroundStyle(.secondary)
                            
                            
                            Spacer()
                            
                            Text(eventViewModel.viewedEvent!.joinedCount != 0 ? Int(ceil(Double(eventViewModel.viewedEvent!.totalPrice / eventViewModel.viewedEvent!.joinedCount!))) : eventViewModel.viewedEvent!.totalPrice, format: .currency(code: "IDR"))
                                .bold()
                        }
                    }
                    .listStyle(.grouped)
                    
                    if eventViewModel.viewedEvent!.paymentProofImageUrl != nil {
                        Section(header: Text("Your Payment Proof")) {
                            AsyncImage(url: URL(string: eventViewModel.viewedEvent!.paymentProofImageUrl!)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            }
                            .frame(maxHeight: 420)
                        }
                    }
                }
                .preferredColorScheme(.dark)
                .ignoresSafeArea(.container, edges: .top)
                
                if eventViewModel.viewedEvent!.paymentProofImageUrl == nil {
                    VStack {
                        Button(action: {
                            paymentSheetIsShowing = true
                        }, label: {
                            Text("Pay")
                                .bold()
                                .frame(maxWidth: .infinity, maxHeight: 32)
                        })
                        .buttonStyle(BorderedProminentButtonStyle())
                        .tint(.orange)
                        .fullScreenCover(isPresented: $paymentSheetIsShowing, onDismiss: {
                            Task {
                                try await eventViewModel.getEventById(eventId: id)
                                
                                try await Task.sleep(nanoseconds: 1000000000)
                                
                                if eventViewModel.viewedEvent?.paymentProofImageUrl != nil {
                                    successSheetIsShowing = true
                                }
                            }
                        }) {
                            PaymentDetailsScreen(
                                isShowing: $paymentSheetIsShowing, paymentAccountNumber: eventViewModel.viewedEvent!.paymentAccountNumber,
                                paymentAccountName: eventViewModel.viewedEvent!.paymentAccountName,
                                paymentAccountBank: eventViewModel.viewedEvent!.paymentAccountBank,
                                price: eventViewModel.viewedEvent!.joinedCount != 0 ? Int(ceil(Double(eventViewModel.viewedEvent!.totalPrice / eventViewModel.viewedEvent!.joinedCount!))) : eventViewModel.viewedEvent!.totalPrice, eventId: id, paymentProofImageUrl: eventViewModel.viewedEvent!.paymentProofImageUrl)
                        }
                    }
                    .padding()
                    .padding(.bottom, 32)
                    .background(Color.black)
                    .frame(alignment: .bottom)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .toolbar(.hidden, for: .tabBar)
            .sheet(isPresented: $successSheetIsShowing) {
                VStack {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .scaledToFill()
                        .foregroundStyle(.green)
                    
                    Text("Payment Successful!")
                        .font(.title)
                        .bold()
                        .padding(.bottom, 8)
                    
                    Text("Your payment proof for the event's rental fees has been successfully uploaded. The coordinator will be notified soon. Thank you!")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    
                    Button("Dismiss") {
                        successSheetIsShowing = false
                    }
                }
                .padding()
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
//    RegistrationDetailScreen()
//}
