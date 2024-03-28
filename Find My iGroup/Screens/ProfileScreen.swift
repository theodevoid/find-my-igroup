//
//  ProfileScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import SwiftUI

struct ProfileScreen: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        VStack(alignment:.leading, spacing: 8) {
                            Text("Theodore Mangowal")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text("tmangowal@gmail.com")
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: EmptyView(), label: {
                        Text("Joined SIGs")
                    })
                } header: {
                    Text("Additional Information")
                }
                
            }
        }
        .navigationTitle("Profile")
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileScreen()
}
