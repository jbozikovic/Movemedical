//
//  NetworkResponse.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

struct NetworkResponse<T> {
    let value: T
    let response: URLResponse
}
