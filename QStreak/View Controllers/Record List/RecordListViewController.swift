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
        viewModel.delegate = self

        viewModel.recordsDidChange = { [weak self] result in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.fetchRecords()
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
        if let record = viewModel.records[indexPath.row] {
            cell.textLabel?.text = "\(record.contactCount)"
            cell.detailTextLabel?.text = "\(record.dateString)"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userTappedRecordCell(indexPath)
    }
}

extension RecordListViewController: RecordListViewModelDelegate {
    func showRecordDetailViewController(recordDetailViewModel: RecordDetailViewModel) {
        if let recordDetailViewController = RecordDetailViewController.initialize(viewModel: recordDetailViewModel) {
            navigationController?.pushViewController(recordDetailViewController, animated: true)
        }

    }
}

extension RecordListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollViewContentHeight = tableView.contentSize.height
        let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height

        if scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging {
            viewModel.fetchRecords()
        }
    }
}
