//
//  Request.swift
//  SwiftShorts
//
//  Created by Sumanth Maddela on 23/07/25.
//

import Foundation

struct Request {
    let page: Int
    private let query = "nature"
    private let perPage = 80
    
    var urlRequest: URLRequest? {
        let baseURL = Constants.baserURL
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "per_page", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        guard let url = urlComponents?.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(Constants.apiKey, forHTTPHeaderField: "Authorization")
        return request
    }
}
