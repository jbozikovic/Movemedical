//
//  AppointmentAPIService.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - AppointmentAPIProtocol
protocol AppointmentAPIProtocol {
    func getAppointments() -> AnyPublisher<[Appointment], Error>
}

////  MARK: - AppointmentAPIService
//class AppointmentAPIService: NSObject, AppointmentAPIProtocol {
//    let networkLayerService: NetworkLayerProtocol
//    
//    init(networkLayerService: NetworkLayerProtocol) {
//        self.networkLayerService = networkLayerService
//    }
//            
//    func getAppointments() -> AnyPublisher<[Appointment], Error> {
//        let url = appointmentsUrl(itemsPerPage: 25, page: 1)
//        let request: HTTPRequest = HTTPRequest(method: .get, url: url, params: nil, headers: nil)
//        return networkLayerService.executeNetworkRequest(request: request)
//            .map(\.value)
//            .eraseToAnyPublisher()
//    }    
//}
//
////  MARK: - Url, header
//private extension AppointmentAPIService {
//    func appointmentsUrl(itemsPerPage: Int, page: Int) -> String {
//        "\(AppUrls.appointments)?maxResults=\(itemsPerPage)&page=\(page)"
//    }
//}
