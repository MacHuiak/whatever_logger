//
//  APIManager.swift
//  hidemy.name_vpn
//
//  Created by Mihail Konoplitskyi on 06.03.2021.
//  Copyright © 2021 4K-SOFT. All rights reserved.
//

import Foundation
import Alamofire
 
class APIManager {
    static let manager: Alamofire.Session = {
        let interceptor = NetworkRequestInterceptor()
        let session = Session(interceptor: interceptor)
        return session
    }()
}
