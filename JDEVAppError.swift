//
//  JDEVAppError.swift
//  JoyDevEvaluationTest
//
//  Created by Denis Sychev on 10/21/21.
//

import Foundation

enum JDETAppError: LocalizedError {
    case serverError(String)
    case clientError(String)
    case coreDataError(String)
    case missingData
    case decodingError(String)
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .serverError(let error):
            return error
        case .clientError(let error):
            return error
        case .decodingError(let error):
            return error
        case .coreDataError(let error):
        return error
        default:
            return "unknown error"
        }
    }
}
