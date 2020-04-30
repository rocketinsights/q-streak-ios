//
//  APIError.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/21/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct APIError: Decodable {
    var errors: [String: [String]]

    func message() -> String {
        return self.errors.map { "\($0.key.snakeCaseToWords()) \($0.value.joined(separator: ", "))" }
                          .joined(separator: " ")
    }
}
