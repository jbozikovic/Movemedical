//
//  ListRepository.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - AppointmentRepositoryProtocol
protocol AppointmentRepositoryProtocol {
    func getAppointments() -> [Appointment]?
    func createAppointment(with date: Date, location: String, info: String) -> Appointment?
    func updateAppointment(_ appointment: Appointment, with date: Date, location: String, info: String) -> Bool
    func deleteAppointment(_ appointment: Appointment) -> Bool
}

//  MARK: - AppointmentRepository
class AppointmentRepository: NSObject, AppointmentRepositoryProtocol {
    private let dbService: AppointmentDBProtocol
//    private let apiService: AppointmentAPIProtocol
    
    init(dbService: AppointmentDBProtocol) {
        self.dbService = dbService
//        self.apiService = apiService
    }
             
    /** Returns appointments from DB. In production app, this function would determine should it return data from API or DB.
    @author Jurica Bozikovic
    */
    func getAppointments() -> [Appointment]? {
        guard shouldFetchFromAPI else {
            return dbService.getAppointments()
        }
//        return apiService.getAppointments()
        return dbService.getAppointments()
    }
    
    func createAppointment(with date: Date, location: String, info: String) -> Appointment? {
        dbService.createAppointment(with: date, location: location, info: info)
    }
    
    func updateAppointment(_ appointment: Appointment, with date: Date, location: String, info: String) -> Bool {
        dbService.updateAppointment(appointment, with: date, location: location, info: info)
    }
    
    func deleteAppointment(_ appointment: Appointment) -> Bool {
        dbService.deleteAppointment(appointment)
    }    
}

//  MARK: - Check should we fetch data from API or not
private extension AppointmentRepository {
    var shouldFetchFromAPI: Bool {
        false
    }
}
