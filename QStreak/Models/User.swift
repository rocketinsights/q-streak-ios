//
//  User.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct User: Codable {
    let age: Int
    let householdSize: Int
    let uuid: String
    let zipCode: String

    enum CodingKeys: String, CodingKey {
        case age
        case householdSize = "household_size"
        case uuid = "uid"
        case zipCode = "zip"
    }
}
