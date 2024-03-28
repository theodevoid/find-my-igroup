//
//  NetworkManager.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import Foundation


final class NetworkManager {
    static let shared = NetworkManager()
    
    static let baseURL = URL(string: "http://localhost:3000", relativeTo: nil)
    
    private init () {}

    public func makeURL(path: String) -> URL {
        guard let pathURL = URL(string: path, relativeTo: NetworkManager.baseURL) else { return NetworkManager.baseURL! }
        
        return pathURL
    }
}
