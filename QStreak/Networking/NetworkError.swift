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

extension NetworkError {
    var message: String {
        switch self {
        case .unknown:
            return "An unknown error has occured. Please try again later..."
        case .noJSONData:
            return ". Please try again later..."
        case .failedJSONDecoding:
            return "Malformed response from server. Please try again later..."
        case .failedBuildingURLRequest:
            return "Unable to access server. Please try again later..."
        case .malformedRequest(let message):
            return "Unsuccessful request: \(message). Please correct errors and try again."
            
        }
    }
}
