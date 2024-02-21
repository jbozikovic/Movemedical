//
//  AppointmentDetailsViewModel.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 19.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - AppointmentDetailsMode
enum AppointmentDetailsMode {
    case add
    case edit
    
    var title: String {
        switch self {
        case .add:
            return AppStrings.add.localized
        case .edit:
            return AppStrings.edit.localized
        }
    }
    
    var showDeleteButton: Bool {
        switch self {
        case .edit:
            return true
        default:
            return false
        }
    }
}

//  MARK: - AppointmentDetailsViewModel
class AppointmentDetailsViewModel: Loadable {
    private(set) var appointment: Appointment?
    private var cancellables = Set<AnyCancellable>()
    
    var date: Date = Date()
    var location: String = ""
    var info: String = ""
    
    private(set) var repository: AppointmentRepositoryProtocol
    var locations: Location = []
    var mode: AppointmentDetailsMode
        
    //  MARK: - Loadable
    var isLoading: Bool = false
    var loadingStatusUpdated: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
            
    // MARK: - Publishers
    lazy var failure = PassthroughSubject<Error, Never>()
    lazy var appointmentsUpdated = PassthroughSubject<Appointment, Never>()
    
    init(mode: AppointmentDetailsMode, appointment: Appointment?, repository: AppointmentRepositoryProtocol) {
        self.mode = mode
        self.appointment = appointment
        self.repository = repository
        loadData()
    }
    
    //  MARK: - Load data
    private func loadData() {
        loadLocations()
        fillDateIfNeeded()
        fillLocationIfNeeded()
        fillInfoIfNeeded()
    }
        
    private func loadLocations() {
        locations = ["San Diego", "St. George", "Park City", "Dallas", "Memphis", "Orlando"]
    }
    
    private func fillDateIfNeeded() {
        guard mode == .edit,
              let currentDate = appointment?.date else { return }
        date = currentDate
    }
    
    private func fillLocationIfNeeded() {
        guard mode == .edit,
              let appointment = appointment else {
            location = locations.first ?? ""
            return
        }
        location = appointment.location
    }
    
    private func fillInfoIfNeeded() {
        guard mode == .edit,
              let appointment = appointment else { return }
        info = appointment.info
    }
}

//  MARK: - Computed properties, user actions
extension AppointmentDetailsViewModel {
    var showDeleteButton: Bool {
        mode.showDeleteButton && appointment != nil
    }
    
    func userTappedSaveButton() {
        guard mode == .edit else { return addAppointment() }
        editAppointment()
    }
    
    func userTappedDeleteButton() {
        deleteAppointment()
    }
}

//  MARK: - Appointment administration (save, delete)
private extension AppointmentDetailsViewModel {
    func addAppointment() {
        guard let appointment = repository.createAppointment(with: date, location: location, info: info) else {
            return failure.send(AppError.genericError)
        }
        appointmentsUpdated.send(appointment)
    }
    
    func editAppointment() {
        guard let appointment = appointment else { return }
        guard repository.updateAppointment(appointment, with: date, location: location, info: info) else {
            return failure.send(AppError.genericError)
        }
        appointmentsUpdated.send(appointment)
    }
    
    func deleteAppointment() {
        guard mode == .edit,
              let appointment = appointment else { return }
        guard repository.deleteAppointment(appointment) else {
            return failure.send(AppError.genericError)
        }
        appointmentsUpdated.send(appointment)
    }
}
