//
//  RecordDetailViewModel.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol RecordDetailViewModelDelegate: AnyObject {
    func submissionDeletionSuccess()
    func submissionDeletionFailure(error: NetworkError)
}

class RecordDetailViewModel {

    // MARK: - Properties

    let alertTitleText = "Unable to delete submission"
    let alertDismissButtonText =  "OK"

    let record: Submission

    let sessionProvider = URLSessionProvider()

    weak var delegate: RecordDetailViewModelDelegate?

    init(record: Submission) {
        self.record = record
    }

    func deleteButtonTapped() {
        sessionProvider.request(type: Submission.self, service: QstreakService.deleteSubmission(date: record.dateString)) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.submissionDeletionSuccess()
            case .failure(let error):
                self?.delegate?.submissionDeletionFailure(error: error)
            }
        }
    }
}
