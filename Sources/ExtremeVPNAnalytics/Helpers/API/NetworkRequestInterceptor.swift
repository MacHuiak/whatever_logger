//
//  NetworkRequestInterceptor.swift
//  hidemy.name_vpn
//
//  Created by Mihail Konoplitskyi on 06.03.2021.
//  Copyright © 2021 4K-SOFT. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import Foundation
#endif

import Alamofire

class NetworkRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        let urlRequest = urlRequest
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        completion(.doNotRetryWithError(error))
    }
}
