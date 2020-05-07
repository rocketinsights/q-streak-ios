//
//  DashboardMessage.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/7/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct DashboardMessage: Decodable {
    let body: String
    let icon: String
    let title: String
    let url: String?
}
