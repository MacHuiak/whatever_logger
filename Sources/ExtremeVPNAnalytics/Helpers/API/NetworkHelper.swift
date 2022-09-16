//
//  NetworkHelper.swift
//  HEAnalytics
//
//  Created by Mihail Konoplitskyi on 02.09.2022.
//

import Foundation
import Alamofire

class NetworkHelper: NSObject {
    // MARK: - Public Methods
    func get<T: Decodable>(apiRoute: ExtremeVPNAnalyticsConstants.APIRoutes, params: [String : Any]? = nil, headers: [String : String] = [:], success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        let httpHeaders = HTTPHeaders(headers)
        APIManager.manager.request(apiRoute.domain + apiRoute.urlString, method: .get, parameters: params, headers: httpHeaders).responseDecodable(of: T.self) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            if let error = response.error {
                failure(strongSelf.getNetworkError(error: error))
            } else {
                if let model = response.value {
                    success(model)
                } else {
                    failure(NetworkError.errorParsingJson)
                }
            }
        }
    }
    
    func get(apiRoute: ExtremeVPNAnalyticsConstants.APIRoutes, params: [String : Any]? = nil, headers: [String : String] = [:], success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void) {
        APIManager.manager.request(apiRoute.domain + apiRoute.urlString, method: .get, parameters: [:], headers: [:]).response { response in
            if let error = response.error {
                failure(error)
            } else {
                if let data = response.data {
                    success(data)
                } else {
                    failure(NetworkError.errorParsingJson)
                }
            }
        }
    }
    
    func post<T: Decodable>(apiRoute: ExtremeVPNAnalyticsConstants.APIRoutes, params: [String : Any]? = nil, headers: [String : String] = [:], success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        let httpHeaders = HTTPHeaders(headers)
        APIManager.manager.request(apiRoute.domain + apiRoute.urlString, method: .post, parameters: params, headers: httpHeaders).responseDecodable(of: T.self) { [weak self] response in
            guard let strongSelf = self else {
                return
            }
            
            if let error = response.error {
                failure(strongSelf.getNetworkError(error: error))
            } else {
                if let model = response.value {
                    success(model)
                } else {
                    failure(NetworkError.errorParsingJson)
                }
            }
        }
    }
}

//MARK: -  helpers and handlers
extension NetworkHelper {
    private func getNetworkError(error: Error?) -> NetworkError {
        if let error = error as? AFError {
            switch error {
            case .invalidURL(let url):
                print("invalidURL \(url)")
            case .parameterEncodingFailed(let reason):
                print("parameterEncodingFailed - \(reason)")
            case .multipartEncodingFailed(let reason):
                print("multipartEncodingFailed \(reason)")
            case .responseValidationFailed(let reason):
                switch reason {
                case .customValidationFailed(error: let error):
                    print("dataFileReadFailed \(error)")
                case .dataFileNil:
                    print("dataFileNil")
                case .dataFileReadFailed(let at):
                    print("dataFileReadFailed \(at)")
                case .missingContentType(let acceptableContentTypes):
                    print("missingContentType \(acceptableContentTypes)")
                case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                    print("acceptableContentTypes \(acceptableContentTypes)\nresponseContentType \(responseContentType)")
                case .unacceptableStatusCode(let code):
                    print("unacceptableStatusCode \(code)")
                }
                
                return .technicalErrorOnClientSide
            case .responseSerializationFailed(let reason):
                switch reason {
                case .inputDataNilOrZeroLength:
                    print("inputDataNilOrZeroLength")
                case .inputFileNil:
                    print("inputFileNil")
                case .inputFileReadFailed(let at):
                    print("inputFileReadFailed \(at)")
                case .stringSerializationFailed(let encoding):
                    print("stringSerializationFailed \(encoding)")
                case .jsonSerializationFailed(let error):
                    print("jsonSerializationFailed \(error)")
                case .decodingFailed(error: let error):
                    print("decodingFailed \(error)")
                case .customSerializationFailed(error: let error):
                    print("customSerializationFailed \(error)")
                case .invalidEmptyResponse(type: let type):
                    print("invalidEmptyResponse \(type)")
                }
                
                return .errorParsingJson
            case .createUploadableFailed(error: let error):
                print("createUploadableFailed \(error)")
            case .createURLRequestFailed(error: let error):
                print("createURLRequestFailed \(error)")
            case .downloadedFileMoveFailed(error: let error, source: _, destination: _):
                print("downloadedFileMoveFailed \(error)")
            case .explicitlyCancelled:
                print("explicitlyCancelled")
            case .parameterEncoderFailed(reason: let reason):
                print("parameterEncoderFailed \(reason)")
            case .requestAdaptationFailed(error: let error):
                print("requestAdaptationFailed \(error)")
            case .requestRetryFailed(retryError: _, originalError: let originalError):
                print("requestRetryFailed \(originalError)")
            case .serverTrustEvaluationFailed(reason: let reason):
                print("serverTrustEvaluationFailed \(reason)")
            case .sessionDeinitialized:
                print("sessionDeinitialized")
            case .sessionInvalidated(error: let error):
                print("sessionInvalidated \(error?.localizedDescription ?? "")")
            case .sessionTaskFailed(error: let error):
                print("sessionTaskFailed \(error)")
            case .urlRequestValidationFailed(reason: let reason):
                print("urlRequestValidationFailed \(reason)")
            }
        } else if let error = error as? URLError {
            if error.code == .networkConnectionLost || error.code == .notConnectedToInternet {
                return .networkIsUnavailable
            } else if error.code == .cannotFindHost || error.code == .cannotConnectToHost {
                return .serverIsUnavailable
            } else if error.code == .timedOut {
                return .requestTimedOut
            }
            
            print(error)
        } else {
            print("Unknown error")
        }
        
        return NetworkError.unknown
    }
}
