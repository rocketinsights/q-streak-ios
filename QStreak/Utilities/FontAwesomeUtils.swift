//
//  FontAwesome.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/7/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct FontAwesomeUtils {
    func stringToUnicode(icon: String) -> String? {
        if let iconNum = Int(icon, radix: 16) {
            if let scalar = UnicodeScalar(iconNum) {
                return String(scalar)
            }
        }

       return ""
    }
}
