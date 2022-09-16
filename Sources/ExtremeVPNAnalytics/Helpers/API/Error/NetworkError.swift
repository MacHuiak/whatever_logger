//
//  NetworkError.swift
//  Touristdoc
//
//  Created by Mihail Konoplitskyi on 20.03.2020.
//  Copyright © 2020 4K-SOFT. All rights reserved.
//

import Foundation

public enum NetworkError: Error {
    case errorSerializationJson
    case errorParsingJson
    case networkIsUnavailable
    case serverIsUnavailable
    case technicalErrorOnClientSide
    case requestTimedOut
    case unknown
    case tokenIsDead
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .technicalErrorOnClientSide:
            return "technical_error_on_client_side".localized()
        case .errorParsingJson:
            return "error_parsing_json".localized()
        case .errorSerializationJson:
            return "error_serialization_json".localized()
        case .networkIsUnavailable:
            return "network_is_unavailable".localized()
        case .serverIsUnavailable:
            return "server_is_unavailable".localized()
        case .requestTimedOut:
            return "request_timed_out".localized()
        case .tokenIsDead:
            return "token_is_dead".localized()
        case .unknown:
            return "unknown_error".localized()
        }
    }
}
