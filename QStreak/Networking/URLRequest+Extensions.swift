//
//  URLRequest+Extensions.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

extension URLRequest {

    init?(service: NetworkService) {
        guard
            let urlComponents = URLComponents(service: service),
            let url = urlComponents.url
            else { return  nil }

        self.init(url: url)

        httpMethod = service.method.rawValue

        service.headers?.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }

        guard let parameters = service.parameters,
            service.parameterEncoding == .json
            else { return }

        httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    }
}
