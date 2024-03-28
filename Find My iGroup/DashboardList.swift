//
//  UpcomingEventList.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 22/03/24.
//

import SwiftUI

struct DashboardList: View {
    var body: some View {
        List {
            Section {
                ZStack {
                    VStack(alignment: .leading) {
                        HStack(spacing: 4) {
                            Text("Basketball")
                                .font(.callout)
                            Spacer()
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Main basket fun match")
                                .foregroundStyle(.primary)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.bottom, 6)
                            
                            
                            HStack(spacing: 8) {
                                Image(systemName: "calendar")
                                    .frame(width: 12)
                                    .padding(.leading, 4)
                                Text(Date()
                                    .formatted(.dateTime.weekday().day().month().year().hour().minute()))
                                .font(.system(size: 12))
                            }
                            .foregroundStyle(.secondary)
                            
                            HStack(spacing: 8) {
                                Image(systemName: "mappin.circle")
                                    .frame(width: 12)
                                    .padding(.leading, 4)
                                Text("Lapangan Basket The Green")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 12)
                            
                            HStack(spacing: 6) {
                                Text(50000, format: .currency(code: "IDR"))
                                    .font(.caption)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundStyle(.white)
                                    .padding(.all, 4)
                                    .background(.blue)
                                    .clipShape(.rect(cornerRadius: 4))
                                Spacer()
                                Text("Unpaid")
                                    .font(.caption)
                                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                    .foregroundStyle(.white)
                                    .padding(.all, 4)
                                    .background(.red)
                                    .clipShape(.rect(cornerRadius: 4))
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    NavigationLink(destination: ContentView()) {
                        EmptyView()
                    }.opacity(0)
                }
                
                
                
            } header: {
                Text("My Events")
                    .padding(.leading, -20)
            }
            .headerProminence(.increased)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Dashboard")
    }
}

#Preview {
    DashboardList()
}
