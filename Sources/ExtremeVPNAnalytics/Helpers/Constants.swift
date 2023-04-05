//
//  Constants.swift
//  HEAnalytics
//
//  Created by Mihail Konoplitskyi on 02.09.2022.
//

import Foundation

public final class ExtremeVPNAnalyticsConstants {
    //event keys
    public enum ExtremeVPNAnalyticsEvent: String {
        case install = "install"
        case startTrial = "trial"
        case renew = "renew"
    }
    
    //API routes
    enum APIRoutes {
        //servers
        case sendEvent
        
        //ipify
        case getMyIP
        
        var urlString: String {
            switch self {
            case .sendEvent:
                return "/api/events"
            case .getMyIP:
                return ""
            }
        }
        
        var domain: String {
            switch self {
            case .sendEvent:
                return AnalyticsAPIService.baseUrl
            case .getMyIP:
                return "https://api64.ipify.org"
            }
        }
    }
}

