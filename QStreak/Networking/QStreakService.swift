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
    case getSubmission(date: String)
    case getSubmissions(page: Int, pageSize: Int)
    case deleteSubmission(date: String)
    case updateSubmission(contactCount: Int, date: String, destinations: [String])
    case getUser
    case getDashboardData
    case getAccount
    case updateAccount(zipCode: String, name: String?)

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
        case .getSubmission(let date), .deleteSubmission(let date), .updateSubmission(_, let date, _):
            return "/submissions/\(date)"
        case .getUser:
            return "/me"
        case .getDashboardData:
            return "/dashboard"
        case .updateAccount:
            return "/account/update"
        case .getAccount:
            return "/me"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .signUp, .createSubmission:
            return .post
        case .getDestinations, .getSubmission, .getSubmissions, .getUser, .getDashboardData, .getAccount:
            return .get
        case .deleteSubmission:
            return .delete
        case .updateSubmission, .updateAccount:
            return .put
        }
    }

    var headers: Headers? {
        switch self {
        case .signUp:
            return ["Content-Type": "application/json"]
        case .createSubmission,
             .getDestinations, .getSubmission, .getSubmissions, .deleteSubmission, .updateSubmission,
             .getUser, .getDashboardData, .getAccount, .updateAccount:
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
        case .updateSubmission(let contactCount, _, let destinations):
            return ["submission": ["contact_count": contactCount,
                                   "destination_slugs": destinations]]
        case .getSubmissions(let page, let pageSize):
            return ["page": page, "page_size": pageSize]
        case .getSubmission(let date), .deleteSubmission(let date):
            return ["": date]
        case .updateAccount(let zipCode, let name):
            return [ "account": [ "zip": zipCode, "name": name]]
        case .getDestinations, .getUser, .getDashboardData, .getAccount:
          return nil
        }
    }

    var parameterEncoding: ParameterEncoding? {
        switch self {
        case .signUp, .createSubmission, .updateSubmission, .updateAccount:
            return .json
        case .getDestinations, .getSubmission, .getSubmissions, .deleteSubmission:
            return .url
        case .getUser, .getDashboardData, .getAccount:
            return nil
        }
    }
}
