//
//  User.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct User: Decodable {
    let name: String?
    let zipCode: String
    let uuid: String
    let location: UserLocation

    enum CodingKeys: String, CodingKey {
        case name
        case location
        case zipCode = "zip"
        case uuid = "uid"
    }
}

struct UserLocation: Decodable {
    let zipCode: String
    let city: String
    let county: String
    let region: String
    let regionCode: String

    enum CodingKeys: String, CodingKey {
        case zipCode = "zip_code"
        case city
        case county
        case region
        case regionCode = "region_code"
    }
}
