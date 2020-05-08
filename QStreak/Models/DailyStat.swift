//
//  DailyStat.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/16/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct DailyStat: Decodable {
    let cases: Int
    let date: String
    let deaths: Int
    let riskLevel: Int
    let location: DailyStatLocation

    enum CodingKeys: String, CodingKey {
        case cases
        case date
        case deaths
        case location
        case riskLevel = "risk_level"
    }
}

struct DailyStatLocation: Decodable {
    let county: String
    let region: String
    let regionCode: String

    enum CodingKeys: String, CodingKey {
        case county
        case region
        case regionCode = "region_code"
    }
}
