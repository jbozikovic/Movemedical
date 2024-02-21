//
//  AppointmentRowViewModel.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 21.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation

class AppointmentRowViewModel {
    var appointment: Appointment
    
    init(appointment: Appointment) {
        self.appointment = appointment
    }
}

extension AppointmentRowViewModel {
    var date: String {
        appointment.date.toString(dateFormat: Constants.dateFormat)
    }
    var time: String {
        appointment.date.toString(dateFormat: Constants.timeFormat)
    }
    var location: String {
        appointment.location
    }
    var desc: String {
        appointment.info
    }
}
