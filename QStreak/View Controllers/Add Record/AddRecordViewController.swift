//
//  AddRecordViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class AddRecordViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var contactCountTextField: UITextField!

    @IBOutlet private weak var dateTextField: UITextField!

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var saveButton: UIButton!

    // MARK: - Properties

    private let viewModel = AddRecordViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        tableView.allowsMultipleSelection = true

        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        dateTextField.text = Date().formattedDate
    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {
        viewModel.saveButtonTapped(date: (dateTextField.inputView as? UIDatePicker)?.date, contactCountString: contactCountTextField.text, selectedIndexPaths: tableView.indexPathsForSelectedRows)
    }

    // MARK: - Methods

    @objc private func datePickerChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AddRecordViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = viewModel.categories[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
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
