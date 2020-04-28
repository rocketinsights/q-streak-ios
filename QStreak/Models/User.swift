//
//  User.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct User: Decodable {

    let uuid: String
    let zipCode: String

    // TODO: add name
    enum CodingKeys: String, CodingKey {
        case uuid = "uid"
        case zipCode = "zip"
    }
}
