//
//  LogEventResponseModel.swift
//  HEAnalytics
//
//  Created by Mihail Konoplitskyi on 02.09.2022.
//

import Foundation

struct LogEventResponseModel: Codable {
    var success: Bool
    var message: String?
}
