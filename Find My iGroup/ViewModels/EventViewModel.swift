//
//  HomeViewModel.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 02/04/24.
//

import Foundation



class EventViewModel: ObservableObject {
    @Published var upcomingEvents = [Event]()
    @Published var viewedEvent: Event?
    @Published var myUpcomingEvents = [Event]()
    @Published var myPastEvents = [Event]()
    
    var networkManager = NetworkManager.shared
    
    let defaults = UserDefaults.standard
    
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
}
