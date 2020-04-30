//
//  User.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct User: Decodable {

    let name: String
    let zipCode: String
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case name
        case zipCode = "zip"
        case uuid = "uid"
    }
}
