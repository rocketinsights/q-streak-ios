//
//  Submission.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/13/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct Submission: Codable {
    let contactCount: Int
    let dateString: String
    let destinations: [String]
    let submissionID: Int

    enum CodingKeys: String, CodingKey {
        case contactCount = "contact_count"
        case dateString = "date"
        case destinations
        case submissionID = "id"
    }
}
