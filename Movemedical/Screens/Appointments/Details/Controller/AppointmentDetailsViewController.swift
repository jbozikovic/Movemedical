//
//  AppointmentDetailsViewController.swift
//  Movemedical
//
//  Created by Jurica Bozikovic on 19.02.2024..
//  Copyright © 2024 CocodeLab. All rights reserved.
//

import UIKit
import Combine
import SnapKit

class AppointmentDetailsViewController: UIViewController, ViewControllerProtocol {
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    private var viewModel: AppointmentDetailsViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var kbValue: CGFloat = 0.0
    
    init(viewModel: AppointmentDetailsViewModel) {
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
        setupTextViewDidChange()
        setupKeyboardObserver()
        setupDatePicker()
        loadData()
        addLocationsMenu()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    private func setupTextViewDidChange() {
        NotificationCenter.default
            .publisher(for: UITextView.textDidChangeNotification , object: descriptionTextView)
                .map { ($0.object as! UITextView).text ?? "" }
                .assign(to: \.info, on: viewModel)
                .store(in: &cancellables)
    }
        
    //  MARK: - Setup GUI
    func setupGUI() {
        title = viewModel.mode.title
        setupNavigationBar()
        setupNavigationBarItems()
        setupBackground()
        addDeleteButtonIfNeeded()
        setupLabels()
        setupSaveButton()
        setupDescriptionTextView()        
    }
    
    private func setupLabels() {
        Utility.setupLabel(dateAndTimeLabel, font: AppUI.defaultFont, textColor: AppUI.bodyFontColor, text: AppStrings.dateTime.localized)
        Utility.setupLabel(locationLabel, font: AppUI.defaultFont, textColor: AppUI.bodyFontColor, text: AppStrings.location.localized)
        Utility.setupLabel(descriptionLabel, font: AppUI.defaultFont, textColor: AppUI.bodyFontColor, text: AppStrings.description.localized)
    }
    
    private func setupSaveButton() {
        saveButton.backgroundColor = AppUI.buttonColor
        saveButton.layer.cornerRadius = AppUI.cornerRadius
        saveButton.setTitle(AppStrings.save.localized, for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.layer.cornerRadius = AppUI.cornerRadius
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
    }
            
    //  MARK: - Handle touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func loadData() {
        datePicker.setDate(viewModel.date, animated: true)
        locationButton.setTitle(viewModel.location, for: .normal)
        descriptionTextView.text = viewModel.info
    }
            
    @IBAction func saveButtonTap(_ sender: UIButton) {
        viewModel.userTappedSaveButton()
    }
}

//  MARK: - Navigation bar item (delete button)
private extension AppointmentDetailsViewController {
    func addDeleteButtonIfNeeded() {
        guard viewModel.showDeleteButton else { return }
        navigationItem.rightBarButtonItems = [Utility.createBarButtonItem(image: AppImages.delete
            .image, target: self, action: #selector(barButtonItemTapped), identifier: "")]
    }
    
    @objc func barButtonItemTapped(sender: UIBarButtonItem) {
        presentAlertController(message: AppStrings.deleteConfirmation.localized, showCancelButton: true) {
            self.viewModel.userTappedDeleteButton()
        }
    }
}

//  MARK: - Date picker
private extension AppointmentDetailsViewController {
    func setupDatePicker() {
        datePicker.addTarget(self, action: #selector(onDateValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func onDateValueChanged(_ datePicker: UIDatePicker) {
        viewModel.date = datePicker.date
    }
}

//  MARK: - KeyboardObserver
private extension AppointmentDetailsViewController {
    func setupKeyboardObserver() {
        KeyboardObserver().keyboardHeightPublisher
            .removeDuplicates()
            .sink(receiveValue: { [weak self] value in
                if value > 0 {
                    self?.kbValue = value / 3
                    self?.view.frame.origin.y -= self?.kbValue ?? 0.0
                } else {
                    self?.view.frame.origin.y += self?.kbValue ?? 0.0
                }
        }).store(in: &cancellables)
    }
}

//  MARK: - Locations menu
private extension AppointmentDetailsViewController {
    func addLocationsMenu() {
        let actionClosure = { (action: UIAction) in
            self.viewModel.location = action.title
        }
        let menuChildren: [UIMenuElement] = viewModel.locations.map { UIAction(title: $0, state: stateForLocationsMenuItem($0), handler: actionClosure) }
        locationButton.menu = UIMenu(options: .displayInline, children: menuChildren)
        locationButton.showsMenuAsPrimaryAction = true
        locationButton.changesSelectionAsPrimaryAction = true
        locationButton.setTitle(viewModel.location, for: .normal)
    }
    
    func stateForLocationsMenuItem(_ location: String) -> UIMenuElement.State {
        location == viewModel.location ? .on : .off
    }
}
    
//  MARK: - View model, callbacks
private extension AppointmentDetailsViewController {
    func setupViewModel() {
        handleFailurePublisher()
    }

    func handleFailurePublisher() {
        viewModel.failure.sink { [weak self] (error) in
            guard let weakSelf = self else { return }
            weakSelf.handleError(error)
        }.store(in: &cancellables)
    }
}
