//
//  Event.swift
//  Find My iFriend
//
//  Created by Theodore Mangowal on 25/03/24.
//

import Foundation

struct Event: Decodable, Identifiable {
    var id: Int
    var title: String
    var organization: String
    var schedule: Date
    var location: String
    var locationMapLink: String
    var estimatedFee: Int
    var requirements: String
    var description: String
    var isJoined: Bool
    var paymentAccountNumber: String
    var paymentAccountName: String
    var paymentAccountBank: String
}