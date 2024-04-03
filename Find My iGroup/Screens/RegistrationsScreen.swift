//
//  PaymentList.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 03/04/24.
//

import SwiftUI

struct RegistrationsScreen: View {
    @StateObject var eventViewModel = EventViewModel()
    
    var body: some View {
        NavigationStack {
            List(eventViewModel.joinedEvents) { event in
                ZStack {
                    VStack(alignment: .leading) {
                        HStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "person.2.fill")
                                    Text(event.organization.capitalized(with: Locale(identifier: "id-ID")))
                                }
                                
                                Text(event.schedule.formatted(.dateTime.day().month().year().hour().minute()))
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                            
                            if event.paymentProofImageUrl == nil {
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
                        .padding(.top)
                        .padding(.horizontal)
                        .padding(.bottom, 8)
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(event.title.uppercased())
                                .font(.title2)
                                .bold()
                                .fixedSize(horizontal: false, vertical: true)
                                .lineLimit(2)
                                .padding(.bottom, 8)
                            
                            Text(event.totalPrice / (event.joinedCount ?? 1), format: .currency(code: "IDR"))
                        }
                        .padding(.bottom, 8)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                    }
                    
                    NavigationLink(destination: RegistrationDetailScreen(id: event.id)) {
                        EmptyView()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(0)
                }
                .listRowInsets(EdgeInsets())
                
            }
            .listRowSpacing(16)
            .navigationTitle("Registrations")
            .onAppear {
                Task {
                    try await eventViewModel.getJoinedEvents()
                }
            }
            .refreshable {
                Task {
                    try await eventViewModel.getJoinedEvents()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    RegistrationsScreen()
}
