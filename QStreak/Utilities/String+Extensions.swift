//
//  String+Extensions.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/22/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

extension String {
    func camelCaseToWords() -> String {
        return self.replacingOccurrences(of: "_", with: " ", options: .regularExpression)
                   .capitalized
    }
}
