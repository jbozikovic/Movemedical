//
//  Constants.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 18.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import Foundation
import UIKit


//  MARK: - Constants
struct Constants {
    private init() {}
            
    static let networkTimeout: TimeInterval = 10     //  network timeout in seconds ...
    static let defaultNumberOfSections: Int = 1
    static let numberOfItemsPerPage: Int = 50
    static let dateFormat: String = "MMM dd, yyyy"
    static let timeFormat: String = "HH:mm"
    static let zeroString = "0"
}


//  MARK: - App config
struct AppConfig {
    private init() {}
}


//  MARK: - AppUI
struct AppUI {
    static let alphaHidden: CGFloat = 0.0
    static let alphaVisible: CGFloat = 1.0
    static let alphaTransparent: CGFloat = 0.5
    static let backgroundColor: UIColor = .white
    static let bodyFontColor: UIColor = .darkGray
    static let bodyFontColorAlt: UIColor = .magenta
    static let bodyFontSize: CGFloat = 15.0
    static let buttonColor: UIColor = .systemMint
    static let checkMarkIcon = "✔︎"
    static let cornerRadius: CGFloat = 8.0
    static let defaultFont = UIFont.systemFont(ofSize: 15.0)
    static let listTitleFont = UIFont.boldSystemFont(ofSize: 17.0)
    static let defaultBgColor: UIColor = .white
    static let navigationBarBGColor: UIColor = .white
    static let navigationBarTintColor: UIColor = .black
    static let navigationBarLargeTitleFont: UIFont = UIFont.boldSystemFont(ofSize: 24.0)
    static let titleFont = UIFont.boldSystemFont(ofSize: 18.0)
    static let titleFontColor: UIColor = .gray
    static let defaultNumberOfLines: Int = 1
    static let separatorColor: UIColor = UIColor(red: 150.0/255.0, green: 167.0/255.0, blue: 175.0/255.0, alpha: 1.0) // .black    
}


//  MARK: - AppImages
enum AppImages: String {
    case add = "plus.app.fill"
    case delete = "trash"
    case noImage = "photo.fill"
        
    var image: UIImage? {
        guard let systemImage = UIImage(systemName: self.rawValue) else {
            return UIImage(named: self.rawValue)
        }
        return systemImage
    }
}


//  MARK: - AppStrings
enum AppStrings: String {
    case add = "add"
    case appointments = "appointments"
    case appointmentDetails = "appointment_details"
    case cancel = "cancel"
    case dateTime = "date_time"
    case deleteConfirmation = "delete_confirmation"
    case description = "description"
    case edit = "edit"
    case fetchDataFailed = "fetch_data_failed"
    case genericErrorMessage = "error_occurred_try_again"
    case location = "location"
    case noData = "no_data"
    case noInternet = "no_internet_connection"
    case ok = "ok"
    case save = "save"
            
    var localized: String {
        return self.rawValue.localized()
    }
}


//  MARK: - AppUrls
struct AppUrls {
    private init() {}
    
    static let baseUrl              = "https://"
    static let appointments         = "appointments"
}


//  MARK: - AppKeys
enum AppKeys {}


//  MARK: - HTTPCode
enum HTTPCode: Int {
    case notAuthorized = 401
    case notFound = 404
    
    func message() -> String {
        switch self {
        case .notAuthorized:
            return ""
        case .notFound:
            return ""
        }
    }
    
    func title() -> String {
        switch self {
        case .notAuthorized:
            return ""
        case .notFound:
            return ""
        }
    }
}


//  MARK: - AppError
enum AppError: Error {
    case genericError
    case noData
    case noInternet
    case fetchDataError
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noData:
            return AppStrings.noData.rawValue
        case .noInternet:
            return AppStrings.noInternet.localized
        case .fetchDataError:
            return AppStrings.fetchDataFailed.localized
        default:
            return AppStrings.genericErrorMessage.localized
        }
    }
}


//  MARK: - Typealiases
typealias JSON = [String: Any]
typealias Location = [String]




