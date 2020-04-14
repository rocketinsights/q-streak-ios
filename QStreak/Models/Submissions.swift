//
//  Submissions.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/13/20.
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
