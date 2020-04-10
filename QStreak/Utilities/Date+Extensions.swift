//
//  Date+Extensions.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        let dateFormat = "yyyy-MM-dd"
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
