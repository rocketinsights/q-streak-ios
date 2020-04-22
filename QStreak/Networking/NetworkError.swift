//
//  NetworkError.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unknown
    case noJSONData
    case failedJSONDecoding
    case failedBuildingURLRequest
    case malformedRequest(message: String)
}
