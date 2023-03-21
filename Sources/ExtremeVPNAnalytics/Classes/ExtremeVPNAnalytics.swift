//
//  ExtremeVPNAnalytics.swift
//  ExtremeVPNAnalytics
//
//  Created by Mihail Konoplitskyi on 01.09.2022.
//

import Foundation

public final class ExtremeVPNAnalytics: NSObject {
    private static let analyitcsAPIService = AnalyticsAPIService()
    
    private static var isUserInstallEventAlreadyLogged: Bool {
        get {
            return UserDefaults.standard.bool(forKey: ExtremeVPNAnalyticsConstants.ExtremeVPNAnalyticsEvent.install.rawValue)
        }
        
        set (newValue) {
            UserDefaults.standard.set(newValue, forKey: ExtremeVPNAnalyticsConstants.ExtremeVPNAnalyticsEvent.install.rawValue)
        }
    }
    
    public static func configure(applicationToken: String) {
        analyitcsAPIService.applicationToken = applicationToken
        checkAndSendInstallEventIfNeeded()
    }
    
    private static func checkAndSendInstallEventIfNeeded() {
        guard isUserInstallEventAlreadyLogged else {
            // could not find install event in user defaults
            // sending this event to server 
            logEvent(eventType: .install)
            return
        }
    }
    
    public static func logEvent(
        eventType: ExtremeVPNAnalyticsConstants.ExtremeVPNAnalyticsEvent,
        params: [String: String]? = nil) {
        analyitcsAPIService.logEvent(eventType: eventType, eventParams: params) {
            if eventType == .install {
                isUserInstallEventAlreadyLogged = true
            }
        }
    }
}
