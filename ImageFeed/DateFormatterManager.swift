//
//  DateFormatterManager.swift
//  ImageFeed
//
//  Created by Victoria Isaeva on 13.08.2023.
//

import Foundation

class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
