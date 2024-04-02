//
//  HomeViewModel.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 02/04/24.
//

import Foundation
import UIKit
import SwiftUI



class EventViewModel: ObservableObject {
    @Published var upcomingEvents = [Event]()
    @Published var viewedEvent: Event?
    @Published var myUpcomingEvents = [Event]()
    @Published var myPastEvents = [Event]()
    @Published var joinedMembers = [User]()
    
    var networkManager = NetworkManager.shared
    
    let defaults = UserDefaults.standard
    
    func getEventMembers(eventId: Int) async throws {
        guard let url = URL(string: "/events/\(eventId)/members", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        let decodedMembers = try decoder.decode([User].self, from: data)

        await MainActor.run {
            joinedMembers = decodedMembers
        }
    }
    
    func getUpcomingEvents() async throws -> [Event] {
        guard let url = URL(string: "/events", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone(identifier: "UTC")
            
            if let date = formatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
        }
        
        let decodedEvents = try decoder.decode([Event].self, from: data)
        
        await MainActor.run {
            upcomingEvents = decodedEvents
        }
        
        return decodedEvents
    }
    
    func getEventById(eventId: Int) async throws -> Event {
        guard let url = URL(string: "/events/\(eventId)", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone(identifier: "UTC")
            
            if let date = formatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
        }
        
        let decodedEvent = try decoder.decode(Event.self, from: data)
        
        await MainActor.run {
            viewedEvent = decodedEvent
        }
        
        return decodedEvent
    }
    
    func getMyUpcomingEvents() async throws -> [Event] {
        guard let url = URL(string: "/events/me/upcoming", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone(identifier: "UTC")
            
            if let date = formatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
        }
        
        let decodedEvents = try decoder.decode([Event].self, from: data)
        
        await MainActor.run {
            myUpcomingEvents = decodedEvents
        }
        
        return decodedEvents
    }
    
    func getMyPastEvents() async throws -> [Event] {
        guard let url = URL(string: "/events/me/past", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let decoder = JSONDecoder()
        
        decoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.timeZone = TimeZone(identifier: "UTC")
            
            if let date = formatter.date(from: dateString) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date format")
            }
        }
        
        let decodedEvents = try decoder.decode([Event].self, from: data)
        
        await MainActor.run {
            myPastEvents = decodedEvents
        }
        
        return decodedEvents
    }
    
    func uploadPaymentAndJoinEvent(eventId: Int, image: UIImage) async throws {
        guard let url = URL(string: "/events/\(eventId)/payment", relativeTo: NetworkManager.baseURL ) else { fatalError("Missing URL") }
        
        let boundary = UUID().uuidString
        
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url)
        var requestData = Data()
        
        print(url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        requestData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        requestData.append("Content-Disposition: form-data; name=\"payment_proof_image\"; filename=\"\(boundary).png\"\r\n".data(using: .utf8)!)
        requestData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        requestData.append(image.pngData()!)
        
        requestData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        urlRequest.setValue("Bearer " + (defaults.string(forKey: "token") ?? ""), forHTTPHeaderField: "Authorization")
        
        session.uploadTask(with: urlRequest, from: requestData, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }
}
