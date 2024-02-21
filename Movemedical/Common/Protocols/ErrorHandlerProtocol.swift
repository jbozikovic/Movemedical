//
//  ErrorHandlerProtocol.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - ErrorHandlerProtocol
protocol ErrorHandlerProtocol: Presentable {
    func handleError(_ error: Error, title: String?)
}

extension ErrorHandlerProtocol where Self: UIViewController {
    func handleError(_ error: Error, title: String? = nil) {
        presentAlertController(title: title, message: error.localizedDescription, showCancelButton: false, confirmHandler: nil)
    }
}
