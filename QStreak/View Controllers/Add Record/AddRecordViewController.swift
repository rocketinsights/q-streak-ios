//
//  AddRecordViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    private let grey = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.00)

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var submissionDateLabel: UILabel!

    @IBOutlet private weak var contactCountTextField: QTextField!

    @IBOutlet private weak var decrementNumberOfPeopleButton: QButton!

    @IBOutlet private weak var incrementNumberOfPeopleButton: QButton!

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {
        viewModel.saveButtonTapped(contactCountString: contactCountTextField.text, selectedIndexPaths: tableView.indexPathsForSelectedRows)
    }

    @IBAction func decrementNumberOfPeopleButtonTapped(_ sender: Any) {
        if let fieldValue = self.contactCountTextField.text {
            let newNum = viewModel.decrementedContactCount(currentCount: fieldValue)

            setDecrementNumberOfPeopleButtonStyles(newNumber: newNum)

            self.contactCountTextField.text = "\(newNum)"
        }
    }

    @IBAction func incrementNumberOfPeopleButtonTapped(_ sender: Any) {
        if let fieldText = self.contactCountTextField.text {
            let newNum = viewModel.incrementedContactCount(currentCount: fieldText)

            setDecrementNumberOfPeopleButtonStyles(newNumber: newNum)

            self.contactCountTextField.text = "\(newNum)"
        }
    }

    @IBAction func contactCountTextFieldEditingChanged(_ sender: Any) {
        if let fieldText = self.contactCountTextField.text {
            if fieldText.isEmpty { return }

            let newNum = Int(fieldText) ?? 0
            setDecrementNumberOfPeopleButtonStyles(newNumber: newNum)
        }
    }

    // MARK: - Properties

    private var viewModel: AddRecordViewModel!

    // MARK: - Initializers

    static func initialize(viewModel: AddRecordViewModel) -> AddRecordViewController? {
        let addRecordViewControllerStoryboard = UIStoryboard(name: String(describing: AddRecordViewController.self), bundle: nil)
        let addRecordViewController = addRecordViewControllerStoryboard.instantiateInitialViewController() as? AddRecordViewController
        addRecordViewController?.viewModel = viewModel
        return addRecordViewController
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44

        setDefaultFieldValues()
    }

    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)

        if let presentationController = presentationController {
            presentationController.delegate?.presentationControllerDidDismiss?(presentationController)
        }
    }

    // MARK: - Methods

    func setDefaultFieldValues() {
        self.submissionDateLabel.text = "\(viewModel.submissionDate.formattedDate(dateFormat: "EEEE MMMM d"))"
        self.contactCountTextField.text = "0"
        self.decrementNumberOfPeopleButton.tintColor = grey
    }

    private func setDecrementNumberOfPeopleButtonStyles(newNumber: Int) {
        if newNumber < 1 {
            self.decrementNumberOfPeopleButton.tintColor = grey
            self.decrementNumberOfPeopleButton.isUserInteractionEnabled = false
        } else {
            self.decrementNumberOfPeopleButton.tintColor = UIColor.black
            self.decrementNumberOfPeopleButton.isUserInteractionEnabled = true
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AddRecordViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as! ActivityCell
        // swiftlint:enable force_cast

        cell.activityCellLabel?.text = viewModel.categories[indexPath.row].name

        let imageName = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false ? "squareCheckboxChecked" : "squareCheckboxUnchecked"
        cell.setImageAs(imageName: imageName)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // swiftlint:disable force_cast
        let cell = tableView.cellForRow(at: indexPath) as! ActivityCell
        // swiftlint:enable force_cast
        cell.setImageAs(imageName: "squareCheckboxChecked")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // swiftlint:disable force_cast
        let cell = tableView.cellForRow(at: indexPath) as! ActivityCell
        // swiftlint:enable force_cast

        cell.setImageAs(imageName: "squareCheckboxUnchecked")
    }
}

extension AddRecordViewController: AddRecordViewModelDelegate {

    func retrievedDestinations() {
        DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
    }

    func addedSubmission(record: RecordDetailViewModel) {
        DispatchQueue.main.async { [weak self] in self?.dismiss(animated: true, completion: nil) }
    }

    func failedSubmission(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
