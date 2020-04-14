//
//  QStreakService.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/10/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

enum QstreakService {
    case signUp(age: Int, householdSize: Int, zipCode: String)
    case createSubmission(contactCount: Int, date: String, destinations: [String])
    case getSubmissions(page: Int)

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
            return "/api/signup"
        case .createSubmission, .getSubmissions:
            return "/api/submissions"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .signUp, .createSubmission:
            return .post
        case .getSubmissions:
            return .get
        }
    }

    var headers: Headers? {
        switch self {
        case .signUp:
            return ["Content-Type": "application/json"]
        case .createSubmission, .getSubmissions:
            return ["Content-Type": "application/json",
                    "authorization": "bearer \(uuid)"]
        }
    }

    var parameters: Parameters? {
        switch self {
        case .signUp(let age, let householdSize, let zipCode):
            return ["account": ["age": age,
                                "household_size": householdSize,
                                "zip": zipCode]]
        case .createSubmission(let contactCount, let date, let destinations):
            return ["submission": ["contact_count": contactCount,
                                   "date": date,
                                   "destinations": destinations]]
        case .getSubmissions(let page):
            return [ "page": page, "page_size": 20 ]
        }
    }

    var parameterEncoding: ParameterEncoding? {
        switch self {
        case .signUp, .createSubmission:
            return .json
        case .getSubmissions:
            return .url
        }
    }
}
