//
//  URLSessionProvider.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

final class URLSessionProvider: NetworkProvider {

    private var session: Networkable

    init(session: Networkable = URLSession.shared) {
        self.session = session
    }

    func request<T>(type: T.Type, service: NetworkService, completion: @escaping (Result<T, NetworkError>) -> Void) where T: Decodable {
        guard let request = URLRequest(service: service) else { return completion(.failure(.failedBuildingURLRequest))}
        let task = session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        })
        task.resume()
    }

    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (Result<T, NetworkError>) -> Void) {
        guard error == nil else { return completion(.failure(.unknown)) }

        guard let response = response else { return completion(.failure(.noJSONData)) }

        switch response.statusCode {
        case 200...299:
            guard let data = data,
                let model = try? JSONDecoder().decode(T.self, from: data)
                else { return completion(.failure(.failedJSONDecoding)) }

            completion(.success(model))
        case 400...499:
            guard let data = data,
                let apiError = try? JSONDecoder().decode(APIError.self, from: data)
                else { return completion(.failure(.failedJSONDecoding)) }
            
            print(apiError)

            completion(.failure(.malformedRequest(message: apiError.message())))
        default:
            completion(.failure(.unknown))
        }
    }
}
