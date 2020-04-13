//
//  NetworkProvider.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol NetworkProvider {
    func request<T>(type: T.Type, service: NetworkService, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable
}
