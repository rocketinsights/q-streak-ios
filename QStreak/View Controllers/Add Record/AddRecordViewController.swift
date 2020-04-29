//
//  AddRecordViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {
    // TODO: move these to a constants file?
    let teal = UIColor(red: 0.55, green: 0.96, blue: 0.82, alpha: 0.30)
    let grey = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.00)

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet weak var submissionDateLabel: UILabel!

    @IBOutlet weak var contactCountTextField: QTextField!

    @IBOutlet weak var decrementNumberOfPeopleButton: UIButton!

    @IBOutlet weak var incrementNumberOfPeopleButton: UIButton!

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {
        viewModel.saveButtonTapped(date: Date(), contactCountString: contactCountTextField.text, selectedIndexPaths: tableView.indexPathsForSelectedRows)
    }

    @IBAction func decrementNumberOfPeopleButtonTapped(_ sender: Any) {
        if let fieldValue = self.contactCountTextField.text {
            let newNum = (Int(fieldValue) ?? 0) - 1

            setDecrementNumberOfPeopleButtonStyles(newNumber: newNum)

            self.contactCountTextField.text = "\(newNum)"
        }
    }

    @IBAction func incrementNumberOfPeopleButtonTapped(_ sender: Any) {
        if let fieldText = self.contactCountTextField.text {
            let newNum = (Int(fieldText) ?? 0) + 1

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

    private let viewModel = AddRecordViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self

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
        self.submissionDateLabel.text = "\(Date().formattedDate(dateFormat: "EEEE MMMM d"))"
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        cell.textLabel?.text = viewModel.categories[indexPath.row].name

        let iconName = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false ? "checkmark.square" : "square"
        cell.imageView?.image = UIImage(systemName: iconName)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.imageView?.image = UIImage(systemName: "checkmark.square")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.imageView?.image = UIImage(systemName: "square")
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
