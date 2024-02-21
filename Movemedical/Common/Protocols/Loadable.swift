//
//  Loadable.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Combine

//  MARK: - Loadable
protocol Loadable: AnyObject {
    var isLoading: Bool { get set }
    var loadingStatusUpdated: PassthroughSubject<Bool, Never> { get }
    func updateLoadingStatus()
}

extension Loadable {
    func updateLoadingStatus() {
        isLoading = !isLoading
        loadingStatusUpdated.send(isLoading)
    }
}

