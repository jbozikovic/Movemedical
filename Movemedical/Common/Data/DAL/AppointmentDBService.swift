//
//  AppointmentDBService.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

//  MARK: - AppointmentDBProtocol
protocol AppointmentDBProtocol {
    func getAppointments() -> [Appointment]?
    func createAppointment(with date: Date, location: String, info: String) -> Appointment?
    func updateAppointment(_ appointment: Appointment, with date: Date, location: String, info: String) -> Bool
    func deleteAppointment(_ appointment: Appointment) -> Bool
}

//  MARK: - AppointmentDBService
class AppointmentDBService: AppointmentDBProtocol {
    private let coreDataService: CoreDataProtocol
    
    init(coreDataService: CoreDataProtocol) {
        self.coreDataService = coreDataService
    }
    
    func getAppointments() -> [Appointment]? {
        guard let items = coreDataService.fetchItems(with: CoreDataServiceConstants.entityAppointment, sortDescriptor: sortDescriptor),
              let appointments = items as? [Appointment] else { return nil }
        return appointments
    }
            
    func createAppointment(with date: Date, location: String, info: String) -> Appointment? {
        guard let entity = coreDataService.createEntity(with: CoreDataServiceConstants.entityAppointment),
              let appointment = entity as? Appointment else {
            return nil
        }
        appointment.date = date
        appointment.location = location
        appointment.info = info
        guard coreDataService.saveContext() else { return nil }
        return appointment
    }
    
    func updateAppointment(_ appointment: Appointment, with date: Date, location: String, info: String) -> Bool {
        appointment.date = date
        appointment.location = location
        appointment.info = info
        return coreDataService.saveContext()
    }
    
    func deleteAppointment(_ appointment: Appointment) -> Bool {
        coreDataService.deleteItem(appointment)
    }
}

private extension AppointmentDBService {
    var sortDescriptor: [NSSortDescriptor] {
        [NSSortDescriptor(key: "date", ascending: true)]
    }
}


