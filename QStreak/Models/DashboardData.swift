//
//  Dashboard.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/7/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct DashboardData: Decodable {
    let dailyStats: DailyStat
    let dashboardMessages: [DashboardMessage]

     enum CodingKeys: String, CodingKey {
        case dailyStats = "daily_stats"
        case dashboardMessages = "messages"
    }
}
