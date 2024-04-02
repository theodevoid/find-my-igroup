//
//  ProfileScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import SwiftUI

struct ProfileScreen: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            if authViewModel.currentUser != nil {
                List {
                    Section {
                        HStack(spacing: 16) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            
                            VStack(alignment:.leading, spacing: 2) {
                                Text(authViewModel.currentUser?.name ?? "")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                Text(verbatim: authViewModel.currentUser!.email)
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
                        Button(action: {
                            authViewModel.logout()
                        }, label: {
                            HStack {
                                Spacer()
                                Text("Log out")
                                    .foregroundStyle(.red)
                                Spacer()
                            }
                            
                        })
                    }
                    
                }
            } else {
                ProgressView()
            }
        }
        .navigationTitle("Profile")
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ProfileScreen()
}
