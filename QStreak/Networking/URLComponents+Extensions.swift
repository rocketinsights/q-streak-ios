//
//  URLComponents+Extensions.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

extension URLComponents {

    init?(service: NetworkService) {
        let url = service.baseURL.appendingPathComponent(service.path)

        self.init(url: url, resolvingAgainstBaseURL: false)

        guard
            let parameters = service.parameters,
            service.parameterEncoding == .url
            else { return }

        queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: String(describing: value))
        }
    }
}
