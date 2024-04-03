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
    var price: Int
    var isJoined: Bool?
    
    var body: some View {
        ZStack(alignment: .center) {
            Image(organization.lowercased())
                .resizable()
                .scaledToFill()
                .frame(height: 200)
            
            LinearGradient(colors: [.clear, .black], startPoint: .topTrailing, endPoint: .bottomLeading)
                .opacity(1)
            
            VStack (alignment: .leading, spacing: 0) {
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    Spacer()
                    Text(schedule.formatted(.dateTime.weekday().day().month().year().hour().minute()))
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Text(title)
                        .foregroundStyle(.primary)
                        .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                        .font(.title2)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                        Text(organization.capitalized(with: Locale(identifier: "id-ID")))
                            .font(.subheadline)
                        
                        Spacer()
                        
//                        Text(price, format: .currency(code: "IDR"))
//                            .foregroundStyle(.indigo)
//                            .fontWeight(.bold)
//                            .padding(.all, 8)
//                            .background(
//                                .foreground
//                            )
//                            .clipShape(.rect(cornerRadius: 8))
//                            .padding()
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
//                .padding(.top)
                .padding(.leading)
                
                Spacer()
//                .padding(.trailing)
                
//                HStack {
//                    Spacer()
//                    Text(price, format: .currency(code: "IDR"))
//                        .foregroundStyle(.indigo)
//                        .fontWeight(.bold)
//                        .padding(.all, 8)
//                        .background(
//                            .foreground
//                        )
//                        .clipShape(.rect(cornerRadius: 8))
//                        .padding()
//                }
            }
        }
        .frame(height: 150)
        
    }
}

#Preview {
    EventListItem(organization: "Badminton", title: "Fun game badminton", schedule: Date(), price: 12000)
}
