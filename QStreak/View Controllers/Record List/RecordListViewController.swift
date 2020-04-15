//
//  RecordListViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class RecordListViewController: UIViewController {
    private enum CellIdentifiers {
      static let record = "recordCell"
    }
    // MARK: - IBOutlets

    @IBOutlet private weak var addRecordBarButtonItem: UIBarButtonItem!

    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties

    private let viewModel = RecordListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self

        tableView.dataSource = self
        tableView.prefetchDataSource = self

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

extension RecordListViewController: UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.record, for: indexPath) as? RecordTableViewCell else { return UITableViewCell() }

        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            cell.configure(with: viewModel.record(at: indexPath.row))
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userTappedRecordCell(indexPath)
    }

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
          viewModel.fetchRecords()
        }
    }
}

extension RecordListViewController: RecordListViewModelDelegate {
    func showRecordDetailViewController(recordDetailViewModel: RecordDetailViewModel) {
        if let recordDetailViewController = RecordDetailViewController.initialize(viewModel: recordDetailViewModel) {
            navigationController?.pushViewController(recordDetailViewController, animated: true)
        }
    }

    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            tableView.reloadData()
            return
        }

        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)

        if indexPathsToReload.count > 0 {
            tableView.reloadRows(at: indexPathsToReload, with: .automatic)
        } else {
            tableView.reloadData()
        }
    }

    func onFetchFailed(with reason: String) {
        // TODO - Handle failed request
        print(reason)
    }
}

private extension RecordListViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= viewModel.currentCount
  }

  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
