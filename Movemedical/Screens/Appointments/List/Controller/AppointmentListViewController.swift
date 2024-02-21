//
//  AppointmentListViewController.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 19.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit
import Combine
import SnapKit

class AppointmentListViewController: UIViewController, ViewControllerProtocol {
    lazy var tableView: UITableView = UITableView(frame: .zero, style: .grouped)
    
    private var viewModel: AppointmentListViewModel
    private var cancellables = Set<AnyCancellable>()
    var dataSource: AppointmentListDataSource? {
        didSet {
            setTableViewDataSourceAndReload()
        }
    }
    
    init(viewModel: AppointmentListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupGUI()
        setupViewModel()
        loadData()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    //  MARK: - Setup GUI
    func setupGUI() {
        title = AppStrings.appointments.localized
        setupNavigationBar()
        setupNavigationBarItems()
        setupBackground()
        setupRightBarButtonItems()
        setupTableView()
        setupConstraints()
    }
        
    private func setTableViewDataSourceAndReload() {
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    private func loadData() {
        dataSource = AppointmentListDataSource(viewModel: viewModel)
    }
}

//  MARK: - Navigation bar item
private extension AppointmentListViewController {
    private func setupRightBarButtonItems() {
        navigationItem.rightBarButtonItems = [Utility.createBarButtonItem(image: AppImages.add
            .image, target: self, action: #selector(barButtonItemTapped), identifier: "")]
    }
    
    @objc func barButtonItemTapped(sender: UIBarButtonItem) {
        viewModel.didTapAddButton.send()
    }
}

//  MARK: - Table view (list)
private extension AppointmentListViewController {
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = AppUI.defaultBgColor
        tableView.separatorColor = AppUI.separatorColor
        tableView.delegate = self
        setupTableViewCell()
    }
    
    private func setupTableViewCell() {
        tableView.register(AppointmentListCell.self, forCellReuseIdentifier: AppointmentListCell.reuseIdentifier)
        tableView.estimatedRowHeight = AppointmentListCell.estimatedHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
}


//  MARK: - Constraints
private extension AppointmentListViewController {
    func setupConstraints() {
        setupTableViewConstraints()
    }
    
    func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
    
//  MARK: - View model
private extension AppointmentListViewController {
    func setupViewModel() {
        handleLoadingStatusUpdated()
        handleFailurePublisher()
        handleShouldReloadDataPublisher()
    }

    func handleLoadingStatusUpdated() {
        viewModel.loadingStatusUpdated.sink { [weak self] (isLoading) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.isHidden = isLoading
                isLoading ? weakSelf.showActivityIndicator() : weakSelf.hideActivityIndicator()
            }
        }.store(in: &cancellables)
    }
    
    func handleFailurePublisher() {
        viewModel.failure.sink { [weak self] (error) in
            guard let weakSelf = self else { return }
            weakSelf.handleError(error)
        }.store(in: &cancellables)
    }

    private func handleShouldReloadDataPublisher() {
        viewModel.shouldReloadData.sink { [weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.tableView.reloadData()
        }.store(in: &cancellables)
    }
}

//  MARK: - UITableViewDelegate
extension AppointmentListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.userSelectedRow(index: indexPath.row)
    }
}
