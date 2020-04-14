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
}

class RecordListViewModel {
    // MARK: - Properties

    var records: [Submission]? {
        didSet { recordsDidChange?(records) }
    }

    var recordsDidChange: (([Submission]?) -> Void)?

    weak var delegate: RecordListViewModelDelegate?

    private let sessionProvider = URLSessionProvider()

    init() {
        self.records = []
    }

    func fetchRecords() {
        sessionProvider.request(type: Submissions.self, service: QstreakService.getSubmissions) { [weak self] result in
            switch result {
            case let .success(submissions):
                self?.records = submissions.records
            case let .failure(error):
                print(error)
            }
        }
    }

    func userTappedRecordCell(_ indexPath: IndexPath) {
        if let selectedRecord = records?[indexPath.row] {
            let recordDetailViewModel = RecordDetailViewModel(record: selectedRecord)

            delegate?.showRecordDetailViewController(recordDetailViewModel: recordDetailViewModel)
        }
    }
 }
