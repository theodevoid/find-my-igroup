//
//  LoginScreen.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 27/03/24.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var viewModel : AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    
    @State private var shouldNavigateToRegister: Bool = false
    
    @State private var isLoading = false
    
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
                    
                    Text("Welcome Back")
                        .font(.largeTitle)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.white)
                        .padding(.bottom, 24)
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email, prompt: Text("Email").foregroundStyle(.gray))
                            .keyboardType(.emailAddress)
                        
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
                        Task {
                            isLoading = true
                            
                            let ONE_SECOND = 1000000000
                            try await Task.sleep(nanoseconds: UInt64(ONE_SECOND))
                            
                            try await viewModel.login(email: email, password: password)
                            isLoading = false
                        }
                    }) {
                        HStack {
                            Spacer()
                            
                            if isLoading {
                                ProgressView()
                            } else {
                                Text("Log in")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.black)
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                        .frame(height: 48)
                        .background(.white)
                        .clipShape(.capsule)
                    }
                    .disabled(isLoading)
                    .padding(.top, 32)
                    
                    NavigationLink(destination: RegisterScreen(), isActive: $shouldNavigateToRegister) {EmptyView()}
                    
                    HStack() {
                        Spacer()
                        Text("Don't have an account?")
                            .foregroundStyle(.white)
                        Button(action: {
                            shouldNavigateToRegister = true
                        }, label: {
                            Text("Register instead")
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
    }
}

#Preview {
    LoginScreen()
}
