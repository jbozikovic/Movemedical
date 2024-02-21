//
//  Date+Extensions.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 21.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
