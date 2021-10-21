//
//  NetworkController.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/19/21.
//

import Foundation


class NetworkController {
    
    public func loadBooks(for url: URL, with completion: @escaping (Result<[JSONBook], JDETAppError>) -> Void) {
        
        let _ = URLSession.shared.dataTask(with: url) { (data, response, error) in
              guard error == nil, let data = data else {
                if let error = error {
                    completion(.failure(.serverError(error.localizedDescription)))
                }
                  return
              }
            
              do {
                  let decoder = JSONDecoder()
                  decoder.dateDecodingStrategy = .iso8601
                  let jsonData = try decoder.decode(BooksJSONResult.self, from: data)
                guard jsonData.booksCount != 0 else {
                    completion(.failure(.missingData))
                    return
                }
                let books = jsonData.books
                  DispatchQueue.main.async {
                    completion(.success(books))
                  }
                } catch {
                    completion(.failure(.missingData))
                }
        }.resume()
    }
}
