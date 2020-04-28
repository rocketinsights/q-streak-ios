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

    @IBOutlet weak var numberOfPeople: QTextField!

    @IBOutlet weak var decrementNumberOfPeopleButton: UIButton!

    @IBOutlet weak var incrementNumberOfPeopleButton: UIButton!

    @IBOutlet weak var dismissSubmissionCreationModal: UIButton!

    var wentOutsideToday = true

    // MARK: - Properties

    private let viewModel = AddRecordViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        tableView.allowsMultipleSelection = true

        setDefaultFieldValues()
    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {
        viewModel.saveButtonTapped(date: Date(), contactCountString: numberOfPeople.text, selectedIndexPaths: tableView.indexPathsForSelectedRows)
    }

    @IBAction func decrementNumberOfPeopleButtonTapped(_ sender: Any) {
        if let fieldValue = self.numberOfPeople.text {
            let newNum = (Int(fieldValue) ?? 0) - 1

            setDecrementNumberOfPeopleButtonStyles(newNumber: newNum)

            self.numberOfPeople.text = "\(newNum)"
        }
    }

    @IBAction func incrementNumberOfPeopleButtonTapped(_ sender: Any) {
        if let fieldText = self.numberOfPeople.text {
            let newNum = (Int(fieldText) ?? 0) + 1

            setDecrementNumberOfPeopleButtonStyles(newNumber: newNum)

            self.numberOfPeople.text = "\(newNum)"
        }
    }

    @IBAction func dismissSubmissionCreationModal(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func numberOfPeopleEditingChanged(_ sender: Any) {
        if let fieldText = self.numberOfPeople.text {
            if fieldText.isEmpty { return }
            let newNum = Int(fieldText) ?? 0

            setDecrementNumberOfPeopleButtonStyles(newNumber: newNum)
        }
    }

    // MARK: - Methods

    func setDefaultFieldValues() {
        self.submissionDateLabel.text = "\(Date().formattedDate(dateFormat: "EEEE MMMM d"))"
        self.numberOfPeople.text = "0"
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath) as? ActivityCell else { return UITableViewCell() }
        cell.activityCellLabel?.text = viewModel.categories[indexPath.row].name

        let iconName = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false ? "checkmark.square" : "square"
        cell.activityCellIcon.image = UIImage(systemName: iconName)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ActivityCell else { return }
        cell.activityCellIcon.image = UIImage(systemName: "checkmark.square")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ActivityCell else { return  }
        cell.activityCellIcon.image = UIImage(systemName: "square")
    }
}

extension AddRecordViewController: AddRecordViewModelDelegate {

    func retrievedDestinations() {
        DispatchQueue.main.async { [weak self] in self?.tableView.reloadData() }
    }

    func addedSubmission(record: RecordDetailViewModel) {
        DispatchQueue.main.async {
            if let recordDetailViewController = RecordDetailViewController.initialize(viewModel: record, comingFromCreation: true) {
                self.navigationController?.pushViewController(recordDetailViewController, animated: true)
            }
        }
    }

    func failedSubmission(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
