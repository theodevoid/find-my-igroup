//
//  MembersList.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 01/04/24.
//

import SwiftUI

struct MembersList: View {
    @ObservedObject var eventViewModel = EventViewModel()
    
    var eventId: Int
    
    var body: some View {
        List(eventViewModel.joinedMembers, id: \.userId) { member in
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                
                Text(member.name)
            }
        }
        .onAppear {
            Task {
                do {
                    try await eventViewModel.getEventMembers(eventId: eventId)
                } catch {
                    print(error)
                }
                
            }
        }
        .refreshable {
            Task {
                try await eventViewModel.getEventMembers(eventId: eventId)
            }
        }
        .navigationTitle("Joined Members (\(eventViewModel.joinedMembers.count))")
    }
}
//
//#Preview {
//    MembersList()
//}
