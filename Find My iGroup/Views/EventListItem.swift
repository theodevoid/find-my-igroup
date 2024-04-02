//
//  EventListItem.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import SwiftUI

struct EventListItem: View {
    //    var id: Int
    var organization: String
    var title: String
    var schedule: Date
    
    var body: some View {
        HStack (alignment: .top) {
            VStack(alignment: .leading) {
                Text(schedule.formatted(.dateTime.weekday().day().month().year().hour().minute()))
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Text(title)
                    .foregroundStyle(.primary)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Text(organization.capitalized(with: Locale(identifier: "id-ID")))
                .font(.subheadline)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke()
                )
        }
    }
}

#Preview {
    EventListItem(organization: "Badminton", title: "Fun game badminton", schedule: Date())
}
