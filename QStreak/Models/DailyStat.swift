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
}
