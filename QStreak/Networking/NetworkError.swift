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
    case unauthorized
    case badRequest
}

extension NetworkError {
    var message: String {
        switch self {
        case .unknown:
            return "An unknown error has occured. Please try again later..."
        case .noJSONData, .badRequest:
            return "Bad request. Please try again later..."
        case .failedJSONDecoding, .failedBuildingURLRequest:
            return "Unable to access server. Please try again later..."
        case .malformedRequest(let message):
            return "\(message). Please correct errors and try again."
        case .unauthorized:
            return "Account cannot be found or you are unauthorized to take that action."
        }
    }
}
