//
//  RecordListViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class RecordListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var addRecordBarButtonItem: UIBarButtonItem!

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let viewModel = RecordListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
    }

    // MARK: - IBActions

    @IBAction private func addRecordBarButtonItemTapped(_ sender: Any) {
        let addRecordStoryboard = UIStoryboard(name: String(describing: AddRecordViewController.self), bundle: nil)
        let addRecordViewController = addRecordStoryboard.instantiateViewController(withIdentifier: String(describing: AddRecordViewController.self))
        present(addRecordViewController, animated: true, completion: nil)
    }

    // MARK: - Methods

    private func setUpNavigationBar() {
        navigationItem.setHidesBackButton(true, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RecordListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.records.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordCell", for: indexPath)
        cell.textLabel?.text = "\(viewModel.records[indexPath.row].contactCount)"
        cell.detailTextLabel?.text = "\(viewModel.records[indexPath.row].creationDate)"
        return cell
    }
}
