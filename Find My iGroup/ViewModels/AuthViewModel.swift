//
//  AuthViewModel.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 28/03/24.
//

import Foundation

struct User: Decodable {
//    var id: String
    var userId: String
    var name: String
    var email: String
    var token: String
    
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    
    var networkManager = NetworkManager.shared
    
    let defaults = UserDefaults.standard
    
    init() {
        if let userId = defaults.string(forKey: "userId") as String?, let name = defaults.string(forKey: "name"),
           let token = defaults.string(forKey: "token"), let email = defaults.string(forKey: "email") {
            if userId != "" {
                self.currentUser = User(userId: userId, name: name, email: email, token: token)
            }
        }
    }
    
    func login(email: String, password: String) async throws {
        guard let url = URL(string: "/auth/login", relativeTo: NetworkManager.baseURL) else { fatalError("Missing URL") }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["email": email, "password": password])
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        print(data)
        
        let decodedUser = try JSONDecoder().decode(User.self, from: data)
        
        self.currentUser = decodedUser
                                
        self.defaults.setValue(self.currentUser?.token, forKey: "token")
        self.defaults.setValue(self.currentUser?.email, forKey: "email")
        self.defaults.setValue(self.currentUser?.name, forKey: "name")
        self.defaults.setValue(self.currentUser?.userId, forKey: "userId")
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return "fail" }
    }
}
