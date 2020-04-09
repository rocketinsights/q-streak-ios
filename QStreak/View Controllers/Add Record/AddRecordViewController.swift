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

    @IBOutlet private weak var tableView: UITableView!

    @IBOutlet private weak var saveButton: UIButton!

    // MARK: - Properties

    private let viewModel = AddRecordViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.allowsMultipleSelection = true
    }

    // MARK: - IBActions

    @IBAction func saveButtonTapped(_ sender: Any) {
        if viewModel.isContactCountValid(contactCountString: contactCountTextField.text) {
            // Todo: Use count, validate selection
            dismiss(animated: true, completion: nil)
        } else {
            // Todo: Handle error
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension AddRecordViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = viewModel.categories[indexPath.row]
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
