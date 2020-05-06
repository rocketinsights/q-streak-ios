//
//  RecordListViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol RecordListViewModelDelegate: AnyObject {
    func showRecordDetailViewController(recordDetailViewModel: RecordDetailViewModel)
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(error: NetworkError)
}

class RecordListViewModel {
    // MARK: - Properties

    let alertTitleText = "Unable to fetch submissions"
    let alertDismissButtonText =  "OK"

    var records: [Submission?] = []
    var currentPage = 1
    var totalPages = 1
    var total = 0

    var currentCount: Int {
        return records.count
    }

    var totalCount: Int {
        return total
    }

    weak var delegate: RecordListViewModelDelegate?

    private var isFetchInProgress = false
    private let sessionProvider = URLSessionProvider()

    func record(at index: Int) -> Submission {
        return records[index]!
    }

    func fetchRecords() {
        guard !isFetchInProgress && totalPages >= currentPage else { return }

        isFetchInProgress = true

        sessionProvider.request(type: PagedSubmissions.self, service: QstreakService.getSubmissions(page: currentPage, pageSize: 20)) { [weak self] result in
            switch result {
            case .success(let response):
                guard let response = response else { return }

                DispatchQueue.main.async {
                    self?.currentPage += 1
                    self?.totalPages = response.totalPages
                    self?.total = response.totalResults
                    self?.isFetchInProgress = false
                    self?.records.append(contentsOf: response.records)

                    let indexPathsToReload = self?.calculateIndexPathsToReload(from: response.records)
                    self?.delegate?.onFetchCompleted(with: indexPathsToReload)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.isFetchInProgress = false
                    self?.delegate?.onFetchFailed(error: error)
                }
            }
        }
    }

    func resetPagination() {
        records = []
        currentPage = 1
        totalPages = 1
        total = 0
    }

    func userTappedRecordCell(_ indexPath: IndexPath) {
        if let selectedRecord = records[indexPath.row] {
            let recordDetailViewModel = RecordDetailViewModel(dateString: selectedRecord.dateString)

            delegate?.showRecordDetailViewController(recordDetailViewModel: recordDetailViewModel)
        }
    }

    private func calculateIndexPathsToReload(from newRecords: [Submission]) -> [IndexPath] {
        let startIndex = records.count - newRecords.count
        let endIndex = startIndex + newRecords.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
 }
