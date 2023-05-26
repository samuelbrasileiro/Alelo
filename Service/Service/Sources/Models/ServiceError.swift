//
//  ServiceError.swift
//  Service
//
//  Created by Samuel Brasileiro on 25/05/23.
//

import Foundation

public enum ServiceError: Error {
    case custom(error: String?, message: String?)
    case dataNotFound
    case dataNotDecoded
    case invalidURL(url: String)
    case invalidStatusCode
    case other(Error)
    
    public static func map(_ error: Error) -> Self {
        return (error as? ServiceError) ?? .other(error)
    }
}

extension ServiceError: LocalizedError {
    public var errorDescription: String? {
        let localized = Localization.Models.Error.self
        switch self {
        case .custom(let error, _): return error
        case .dataNotFound: return localized.DataNotFound.title
        case .dataNotDecoded: return localized.DataNotDecoded.title
        case .invalidURL(let url): return localized.InvalidURL.title(url)
        case .invalidStatusCode: return localized.InvalidStatusCode.title
        case .other(let error): return error.localizedDescription
        }
    }
    
    public var failureReason: String? {
        let localized = Localization.Models.Error.self
        switch self {
        case .custom(_, let message): return message
        case .dataNotFound: return localized.DataNotFound.comment
        case .dataNotDecoded: return localized.DataNotDecoded.comment
        case .invalidURL: return localized.InvalidURL.comment
        case .invalidStatusCode: return localized.InvalidStatusCode.comment
        case .other: return nil
        }
    }
}

struct ErrorCodable: Codable {
    var error: String?
    var message: String?
    
    var serviceError: ServiceError {
        return .custom(error: error, message: message)
    }
}
