//
//  Submission.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/13/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

struct PagedSubmissions: Codable {
    let currentPage: Int
    let pageSize: Int
    let totalPages: Int
    let totalResults: Int
    let records: [Submission]

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case pageSize = "page_size"
        case totalPages = "total_pages"
        case totalResults = "total_results"
        case records = "submissions"
    }
}

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
