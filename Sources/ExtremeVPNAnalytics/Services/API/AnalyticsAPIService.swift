//
//  AnalyticsAPIService.swift
//  HEAnalytics
//
//  Created by Mihail Konoplitskyi on 02.09.2022.
//

#if os(macOS)
    import Cocoa
#else
    import Foundation
    import UIKit
#endif


class AnalyticsAPIService: NSObject {
    private let api = NetworkHelper()
    var applicationToken: String = ""
    
    func logEvent(eventType: ExtremeVPNAnalyticsConstants.ExtremeVPNAnalyticsEvent, success: @escaping () -> ()) {
        guard !applicationToken.isEmpty else {
            debugPrint("\(type(of: self)) - failed to log \(eventType.rawValue) event - application token is empty")
            return
        }
        
        getCurrentIPAddress { currentIP in
            let params = self.preparePOSTParamsArray(eventType: eventType)
            let header = ["cf-connecting-ip": currentIP]
            
            self.api.post(apiRoute: .sendEvent, params: params, headers: header) { (logEventResponseModel: LogEventResponseModel) in
                debugPrint("\(type(of: self)) - successfully sent \(eventType.rawValue) event")
                
                if logEventResponseModel.success {
                    success()
                }
            } failure: { error in
                debugPrint("\(type(of: self)) - failed to log \(eventType.rawValue) event - \(error.localizedDescription)")
            }
        }
    }
    
    private func getCurrentIPAddress(completion: @escaping (String) -> ()) {
        api.get(apiRoute: .getMyIP) { data in
            guard let responseString = String(data: data, encoding: .utf8) else {
                return
            }
            
            let responseArray = responseString.split(separator: "\n")
            responseArray.forEach { responseItem in
                let values = responseItem.split(separator: "=")
                if values.count == 2 && values[0] == "ip" {
                    completion(String(values[1]))
                    return
                }
            }
        } failure: { error in
            print(error.localizedDescription)
        }
    }
    
    private func preparePOSTParamsArray(eventType: ExtremeVPNAnalyticsConstants.ExtremeVPNAnalyticsEvent) -> [String:String] {
        #if os(macOS)
            guard let width = NSScreen.main?.frame,
                  let height = NSScreen.main?.frame.height else {
                return [:]
            }
        
            let screenWidth = String(describing: width)
            let screenHeight = String(describing: height)
        #else
            let screenWidth = String(describing: Int(UIScreen.main.bounds.width))
            let screenHeight = String(describing: Int(UIScreen.main.bounds.height))
        #endif
        
        
        let appVersionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "Unknown"
        let appBuildVersionNumber = Bundle.main.infoDictionary?["CFBundleVersion"] ?? "Unknown"
        let appVersion = "v\(appVersionNumber) b\(appBuildVersionNumber)"

        #if os(macOS)
        let device = "MacOS v\(ProcessInfo.processInfo.operatingSystemVersion)"
        #else
            let device = "iOS v\(UIDevice.current.systemVersion)"
        #endif
        
        return ["type": eventType.rawValue,
                "app_token": applicationToken,
                "screen_width": screenWidth,
                "screen_height": screenHeight,
                "device": device,
                "app_version": appVersion]
    }
}
