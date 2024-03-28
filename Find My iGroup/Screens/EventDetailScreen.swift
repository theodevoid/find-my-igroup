//
//  EventDetailScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 26/03/24.
//

import SwiftUI

struct EventDetailScreen: View {
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                AsyncImage(url: URL(string: "https://plus.unsplash.com/premium_photo-1677543938193-6050960bef16")) {
                    phase in switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(minWidth: 0)
                    case .failure:
                        Image(systemName: "wifi.slash")
                    @unknown default:
                        EmptyView()
                    }
                }
                
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(Date().formatted(.dateTime.day().month().year().hour().minute()))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Badminton Fun")
                                .font(.title)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .padding(.bottom, -6)
                            Text("Badminton")
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(
                                    Color.gray
                                )
                                .clipShape(.rect(cornerRadius: 16))
                                .foregroundStyle(.white)
                        }
                        
                        Spacer()
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Text(50000, format: .currency(code: "IDR"))
                                .font(.subheadline)
                                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                                .foregroundStyle(.white)
                                .padding(.all, 4)
                                .padding(.horizontal, 4)
                                .background(.blue)
                                .clipShape(.rect(cornerRadius: 16))
                        })
                    }
                    
                }
                .padding(.all, 16)
                .background(
                    LinearGradient(colors: [.white, .clear], startPoint: .bottom, endPoint: .center)
                )
            }
            .frame(width: .infinity, height: 274)
            
            Spacer()
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    EventDetailScreen()
}
