//
//  User.swift
//  Find My iGroup
//
//  Created by Theodore Mangowal on 02/04/24.
//

import Foundation

struct User: Decodable {
//    var id: String
    var userId: String
    var name: String
    var email: String
    var token: String?
}
