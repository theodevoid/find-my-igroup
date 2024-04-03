//
//  AuthViewModel.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 28/03/24.
//

import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var joinedSigs = [Int]()
    
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
    
    func getJoinedSigs() async throws {
        guard let url = URL(string: "/users/sigs", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        let decodedSigs = try decoder.decode([SIG].self, from: data)
        
        await MainActor.run {
            joinedSigs = decodedSigs.map { $0.id }
        }
    }
    
    func updateJoinedSigs(sigIds: [Int]) async throws {
        guard let url = URL(string: "/users/sigs", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["sigIds": sigIds])
        urlRequest.httpBody = jsonData
        
        let (_, _) = try await URLSession.shared.data(for: urlRequest)
        
        try await self.getJoinedSigs()
    }
    
    func login(email: String, password: String) async throws {
        guard let url = URL(string: "/auth/login", relativeTo: NetworkManager.baseURL) else { fatalError("Missing URL") }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["email": email, "password": password, "deviceToken": defaults.string(forKey: "deviceToken")])
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        print(data)
        
        let decodedUser = try JSONDecoder().decode(User.self, from: data)
        
        print(decodedUser)
        
        self.currentUser = decodedUser
                                
        self.defaults.setValue(self.currentUser?.token, forKey: "token")
        self.defaults.setValue(self.currentUser?.email, forKey: "email")
        self.defaults.setValue(self.currentUser?.name, forKey: "name")
        self.defaults.setValue(self.currentUser?.userId, forKey: "userId")
//        guard (response as? HTTPURLResponse)?.statusCode == 200 else { return "fail" }
    }
    
    func register(name: String, email: String, password: String) async throws {
        guard let url = URL(string: "/auth/register", relativeTo: NetworkManager.baseURL) else { fatalError("Missing URL") }
        
        let jsonData = try? JSONSerialization.data(withJSONObject: ["email": email, "password": password, "name": name])
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let (_, _) = try await URLSession.shared.data(for: urlRequest)
        
//        try await login(email: email, password: password)
    }
    
    func logout() {
        self.currentUser = nil
        
        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "name")
        defaults.removeObject(forKey: "token")
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "deviceToken")
    }
}
