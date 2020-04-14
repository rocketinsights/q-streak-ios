//
//  NetworkService.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

typealias Headers = [String: String]
typealias Parameters = [String: Any]

protocol NetworkService {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: Headers? { get }
    var parameters: Parameters? { get }
    var parameterEncoding: ParameterEncoding { get }
}
