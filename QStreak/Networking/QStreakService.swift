//
//  QStreakService.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

enum QstreakService {
    case signUp(name: String?, zipCode: String)
    case createSubmission(contactCount: Int, date: String, destinations: [String])
    case getDestinations
    case getSubmissions(page: Int, pageSize: Int)
    case deleteSubmission(submissionId: Int)

    var uuid: String { return UserDefaults.standard.string(forKey: "uuid") ?? "" }
}

// MARK: - NetworkService

extension QstreakService: NetworkService {

    var baseURL: URL {
        return URL(string: "http://127.0.0.1:4000")!
    }

    var path: String {
        switch self {
        case .signUp:
            return "/signup"
        case .createSubmission, .getSubmissions:
            return "/submissions"
        case .getDestinations:
            return "/destinations"
        case .deleteSubmission(let submissionId):
            return "/submissions/\(submissionId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .signUp, .createSubmission:
            return .post
        case .getDestinations, .getSubmissions:
            return .get
        case .deleteSubmission:
            return .delete
        }
    }

    var headers: Headers? {
        switch self {
        case .signUp:
            return ["Content-Type": "application/json"]
        case .createSubmission, .getDestinations, .getSubmissions, .deleteSubmission:
            return ["Content-Type": "application/json",
                    "authorization": "bearer \(uuid)"]
        }
    }

    var parameters: Parameters? {
        switch self {
        case .signUp(let name, let zipCode):
            return ["account": ["name": name,
                                "zip": zipCode]]
        case .createSubmission(let contactCount, let date, let destinations):
            return ["submission": ["contact_count": contactCount,
                                   "date": date,
                                   "destination_slugs": destinations]]
        case .getSubmissions(let page, let pageSize):
            return [ "page": page, "page_size": pageSize ]        
        case .getDestinations, .deleteSubmission:
          return nil
        }
    }

    var parameterEncoding: ParameterEncoding? {
        switch self {
        case .signUp, .createSubmission:
            return .json
        case .getSubmissions, .getDestinations, .deleteSubmission:
            return .url
        }
    }
}
