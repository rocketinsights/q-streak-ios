//
//  Date+Extensions.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

extension Date {
    func formattedDate(dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }

    static func date(for dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)
    }
}
