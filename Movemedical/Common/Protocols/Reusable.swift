//
//  Reusable.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - Reusable
protocol Reusable {
    static var reuseIdentifier: String { get }
    static var estimatedHeight: CGFloat { get }
}

extension Reusable where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

