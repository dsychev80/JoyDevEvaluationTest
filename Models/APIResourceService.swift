//
//  APIResourceService.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/19/21.
//

import Foundation

protocol ApiResource {
    associatedtype ModelType: Decodable
    var parameters: [String: String] { get set }
}

struct Constants {
    static let apiPlatformURL = "https://demo.api-platform.com/books?"
}

extension ApiResource {
    var url: URL {
        let baseUrl = URL(string: Constants.apiPlatformURL)!
        return baseUrl.appendingParameters(parameters)
    }
}

struct BooksResource: ApiResource {
    typealias ModelType = [JSONBook]
    var parameters: [String : String] = ["page": "1"]
    
    mutating func page(_ number: Int) {
        self.parameters.updateValue(String(number), forKey: "page")
    }

}

extension URL {
    func appendingParameters(_ parameters: [String: String]) -> URL {
        var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        var queryItems = urlComponents.queryItems ?? []
        for key in parameters.keys {
            queryItems.append(URLQueryItem(name: key, value: parameters[key]))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}
