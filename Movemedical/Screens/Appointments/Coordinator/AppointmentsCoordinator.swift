//
//  AppointmentsCoordinator.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 19.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit
import Combine

class AppointmentsCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    var viewModel: AppointmentListViewModel?
    var repository: AppointmentRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
        
    init(presenter: UINavigationController) {
        self.presenter = presenter
        childCoordinators = []
        let dbService = AppointmentDBService(coreDataService: CoreDataService())
        repository = AppointmentRepository(dbService: dbService)
    }
    
    func start() {
        setupViewModel()
        navigateToListViewController()
    }
}

//  MARK: - View model
private extension AppointmentsCoordinator {
    private func setupViewModel() {
        viewModel = AppointmentListViewModel(repository: repository)
        handleDidTapListItemPublisher()
        handleDidTapAddButtonPublisher()
    }
    
    func handleDidTapListItemPublisher() {
        viewModel?.didTapListItem.sink { [weak self] (item) in
            guard let weakSelf = self else { return }
            weakSelf.navigateToEditView(appointment: item)
        }.store(in: &cancellables)
    }
    
    func handleDidTapAddButtonPublisher() {
        viewModel?.didTapAddButton.sink { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.navigateToAddView()
        }.store(in: &cancellables)
    }
}

//  MARK: - Appointments list
private extension AppointmentsCoordinator {
    private func navigateToListViewController() {
        guard let vm = viewModel else { return }
        let vc = AppointmentListViewController(viewModel: vm)
        presenter.pushViewController(vc, animated: true)
    }
}

//  MARK: - Appointments details (add / edit)
private extension AppointmentsCoordinator {
    func navigateToEditView(appointment: Appointment) {
        let vm = AppointmentDetailsViewModel(mode: .edit, appointment: appointment, repository: repository)
        navigateToDetailsView(viewModel: vm)
    }
    
    func navigateToAddView() {
        let vm = AppointmentDetailsViewModel(mode: .add, appointment: nil, repository: repository)
        navigateToDetailsView(viewModel: vm)
    }
    
    func navigateToDetailsView(viewModel: AppointmentDetailsViewModel) {
        viewModel.appointmentsUpdated.sink { [weak self] appointment in
            guard let weakSelf = self else { return }
            weakSelf.presenter.popViewController(animated: true)
            weakSelf.viewModel?.refreshData()
        }.store(in: &cancellables)
        
        let vc = AppointmentDetailsViewController(viewModel: viewModel)
        presenter.pushViewController(vc, animated: true)
    }
}

