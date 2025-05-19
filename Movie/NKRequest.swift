//
//  NKRequest.swift
//  Movie
//
//  Created by Suresh Kumar on 18/05/25.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

final class NKRequest {
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var queryItems: [URLQueryItem]?
    var body: Encodable?
    var headers: [String: String]?

    init(baseURL: String,
         path: String,
         method: HTTPMethod,
         queryItems: [URLQueryItem]? = nil,
         body: Encodable? = nil,
         headers: [String: String]? = nil) {

        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.body = body
        self.headers = headers ?? [
            "Content-Type": "application/json"
        ]
    }

    var url: URL? {
        guard var components = URLComponents(string: baseURL) else {
            print("Invalid base URL")
            return nil
        }

        // Ensure proper path combination
        let trimmedBasePath = components.path.hasSuffix("/") ? String(components.path.dropLast()) : components.path
        let fullPath = path.hasPrefix("/") ? path : "/" + path
        components.path = trimmedBasePath + fullPath

        components.queryItems = queryItems
        return components.url
    }

    var urlRequest: URLRequest? {
        guard let url = url else {
            print("Failed to build URL from components")
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.allHTTPHeaderFields = headers

        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
            } catch {
                print("Failed to encode request body: \(error)")
                return nil
            }
        }

        return request
    }
}

struct AnyEncodable: Encodable {
    private let encodeClosure: (Encoder) throws -> Void

    init<T: Encodable>(_ wrapped: T) {
        encodeClosure = wrapped.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeClosure(encoder)
    }
}
