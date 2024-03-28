//
//  EventListItem.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import SwiftUI

struct EventListItem: View {
//    var id: Int
//    var organization: String
//    var title: String
//    var schedule: Date
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Basketball")
                    .font(.callout)
                Divider()
                Text("Main basket fun match")
                    .foregroundStyle(.primary)
                Text(Date().formatted(.dateTime.weekday().day().month().year().hour().minute()))
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    EventListItem()
}
