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
                    HStack(spacing: 16) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                        
                        VStack(alignment:.leading, spacing: 2) {
                            Text("Theodore Mangowal")
                                .font(.title3)
                                .fontWeight(.bold)
                            Text(verbatim: "tmangowal@gmail.com")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section {
                    NavigationLink(destination: SIGSelectionScreen(), label: {
                        Text("Joined SIGs")
                    })
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Edit Profile")
                    })
                } header: {
                    Text("Additional Information")
                }
                
                Section {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        HStack {
                            Spacer()
                            Text("Log out")
                                .foregroundStyle(.red)
                            Spacer()
                        }
                        
                    })
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
