//
//  AppointmentListDataSource.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 19.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

class AppointmentListDataSource: NSObject {
    private let viewModel: AppointmentListViewModel

    init(viewModel: AppointmentListViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDataSource
extension AppointmentListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppointmentListCell.reuseIdentifier, for: indexPath) as! AppointmentListCell
        if let item: AppointmentRowViewModel = viewModel.getItemAtIndex(indexPath.row) {
            cell.configure(item)
        }
        return cell        
    }
                
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        viewModel.deleteAppointment(at: indexPath.row)
    }
}



