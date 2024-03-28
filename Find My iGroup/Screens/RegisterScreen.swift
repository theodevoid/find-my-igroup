//
//  RegisterScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 27/03/24.
//

import SwiftUI

struct RegisterScreen: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var email: String = ""
    @State private var fullName: String = ""
    @State private var password: String = ""
    
    @State private var shouldNavigateToLogin: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomLeading) {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .clipShape(.rect(topTrailingRadius: 100))
                            .foregroundStyle(.black)
                            .opacity(0.9)
                            .ignoresSafeArea()
                            .frame(height: geometry.size.height - (geometry.size.height * 0.2))
                    }
                }
                
                VStack(alignment: .leading) {
                    Spacer()
                    
                    Text("Register your account")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .padding(.bottom, 24)
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email, prompt: Text("Email").foregroundStyle(.gray))
                        
                        Divider()
                            .overlay(Color.gray)
                        
                        TextField("Full Name", text: $email, prompt: Text("Full Name").foregroundStyle(.gray))
                        
                        Divider()
                            .overlay(Color.gray)
                        
                        SecureField("Password", text: $password, prompt: Text("Password").foregroundStyle(.gray))
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray)
                    )
                    
                    Button(action: {
                        
                    }) {
                        HStack {
                            Spacer()
                            Text("Register")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.black)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .frame(height: 48)
                        .background(.white)
                        .clipShape(.capsule)
                    }
                    .padding(.top, 32)
                    HStack() {
                        Spacer()
                        
                        Text("Already have an account?")
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Log in")
                        })
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            .ignoresSafeArea()
        }
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    RegisterScreen()
}
