//
//  AppointmentListCell.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 19.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit

// MARK: - AppointmentListCellConstants
private struct AppointmentListCellConstants {
    private init() {}
    
    static let infoNumberOfLines: Int = 2
    static let offset: CGFloat = 10.0
    static let leadingTrailingOffset: CGFloat = 20.0
    static let labelHeight: CGFloat = 21.0
}

// MARK: - AppointmentListCell
class AppointmentListCell: UITableViewCell, Configurable {
    typealias T = AppointmentRowViewModel
    lazy var dateLabel = UILabel(frame: .zero)
    lazy var timeLabel = UILabel(frame: .zero)
    lazy var locationLabel = UILabel(frame: .zero)
    lazy var infoLabel = UILabel(frame: .zero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(_ item: AppointmentRowViewModel) {
        setupGUI()
        dateLabel.text = item.date
        timeLabel.text = item.time
        locationLabel.text = item.location
        infoLabel.text = item.desc
    }
}


// MARK: - Setup GUI
private extension AppointmentListCell {
    func setupGUI() {
        backgroundColor = .clear
        addSubviews()        
        setupLabels()
        setupConstraints()
    }
    
    func addSubviews() {
        [dateLabel, timeLabel, locationLabel, infoLabel].forEach { subView in
            addSubview(subView)
        }
    }
    
    func setupLabels() {
        Utility.setupLabel(dateLabel, font: AppUI.titleFont, textColor: AppUI.titleFontColor, numberOfLines: 0, textAlignment: .center)
        Utility.setupLabel(timeLabel, font: AppUI.listTitleFont, textColor: AppUI.titleFontColor)
        Utility.setupLabel(locationLabel, font: AppUI.defaultFont, textColor: .black)
        Utility.setupLabel(infoLabel, font: AppUI.defaultFont, textColor: AppUI.bodyFontColor, numberOfLines: AppointmentListCellConstants.infoNumberOfLines)
    }
}


// MARK: - Setup constraints
private extension AppointmentListCell {
    func setupConstraints() {
        setupDateLabelConstraints()
        setupTimeLabelConstraints()
        setupLocationLabelConstraints()
        setupInfoLabelConstraints()
    }

    func setupDateLabelConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppointmentListCellConstants.offset)
            make.leading.equalToSuperview().offset(AppointmentListCellConstants.leadingTrailingOffset)
            make.width.equalTo(70)
            make.bottom.equalToSuperview().offset(AppointmentListCellConstants.offset)
        }
    }

    func setupTimeLabelConstraints() {
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppointmentListCellConstants.offset)
            make.leading.equalTo(dateLabel.snp.trailing).offset(AppointmentListCellConstants.offset)
            make.trailing.equalToSuperview().offset(-AppointmentListCellConstants.leadingTrailingOffset)
            make.height.equalTo(AppointmentListCellConstants.labelHeight)
        }
    }

    func setupLocationLabelConstraints() {
        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(AppointmentListCellConstants.offset)
            make.leading.equalTo(timeLabel.snp.leading)
            make.height.equalTo(AppointmentListCellConstants.labelHeight)
            make.trailing.equalToSuperview().offset(-AppointmentListCellConstants.leadingTrailingOffset)
        }
    }

    func setupInfoLabelConstraints() {
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(AppointmentListCellConstants.offset)
            make.leading.equalTo(timeLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-AppointmentListCellConstants.leadingTrailingOffset)
            make.height.greaterThanOrEqualTo(AppointmentListCellConstants.labelHeight)
            make.bottom.equalToSuperview().offset(-AppointmentListCellConstants.offset)
        }
    }
}


// MARK: - Reusable
extension AppointmentListCell: Reusable {
    static var estimatedHeight: CGFloat {
        return 100.0
    }
}
