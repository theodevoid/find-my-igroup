//
//  AuthViewModel.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 28/03/24.
//

import Foundation

struct User {
    var id: Int
    var fullName: String
    var email: String
    var token: String
    
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    
    func login(email: String, password: String) {
        self.currentUser = User(id: 1, fullName: "Full Name", email: email, token: "token")
    }
}
