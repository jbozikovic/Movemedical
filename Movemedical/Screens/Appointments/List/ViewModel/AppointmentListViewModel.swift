//
//  AppointmentListViewModel.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 19.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import Combine

//  MARK: - AppointmentListViewModel
class AppointmentListViewModel: Loadable {
    private(set) var appointments: [Appointment] = [] {
        didSet{
            self.prepareDataAndReload()
        }
    }
    private(set) var cellViewModels: [AppointmentRowViewModel] = []
    private(set) var repository: AppointmentRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
        
    //  MARK: - Loadable
    var isLoading: Bool = false
    var loadingStatusUpdated: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
            
    // MARK: - Publishers
    lazy var didTapListItem = PassthroughSubject<Appointment, Never>()
    lazy var didTapAddButton = PassthroughSubject<Void, Never>()
    lazy var failure = PassthroughSubject<Error, Never>()
    lazy var shouldReloadData = PassthroughSubject<Void, Never>()
                    
    init(repository: AppointmentRepositoryProtocol) {
        self.repository = repository
        loadData()
    }
    
    //  MARK: - Load data
    func loadData() {
        updateLoadingStatus()
        guard let items = repository.getAppointments() else {
            failure.send(AppError.noData)
            return
        }
        appointments = items
        updateLoadingStatus()
    }
    
    //  MARK: - Prepare view models (for cells)
    private func prepareDataAndReload() {
        cellViewModels = []
        cellViewModels.append(contentsOf: appointments.map { AppointmentRowViewModel(appointment: $0) })
        shouldReloadData.send()
    }
            
    func refreshData() {
        loadData()
    }
    
    func deleteAppointment(at index: Int) {
        guard let item = getItemAtIndex(index) else { return }
        guard repository.deleteAppointment(item.appointment) else {
            return failure.send(AppError.genericError)
        }
        refreshData()
    }
}

//  MARK: - Number of items,views visibility...
extension AppointmentListViewModel {
    var numberOfItems: Int {
        return cellViewModels.count
    }
    var numberOfSections: Int {
        return Constants.defaultNumberOfSections
    }
        
    func getItemAtIndex(_ index: Int) -> AppointmentRowViewModel? {
        guard !cellViewModels.isEmpty, index < cellViewModels.count else { return nil }
        return cellViewModels[index]
    }

    func userSelectedRow(index: Int) {
        guard let vm = getItemAtIndex(index) else { return }
        didTapListItem.send(vm.appointment)
    }
}
