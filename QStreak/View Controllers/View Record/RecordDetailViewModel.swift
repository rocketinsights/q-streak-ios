//
//  RecordDetailViewModel.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol RecordDetailViewModelDelegate: AnyObject {
    func retrievedSubmission()
    func submissionDeletionSuccess()
    func submissionDeletionFailure(error: NetworkError)
}

class RecordDetailViewModel {

    // MARK: - Properties

    let alertTitleText = "Unable to delete submission"

    let alertDismissButtonText =  "OK"

    var record: Submission?

    let sessionProvider = URLSessionProvider()

    weak var delegate: RecordDetailViewModelDelegate?

    let submissionDateString: String

    init(dateString: String) {
        submissionDateString = dateString
        retrieveSubmission()
    }

    func retrieveSubmission() {
        sessionProvider.request(type: Submission.self, service: QstreakService.getSubmission(date: submissionDateString)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let submission):
                self.record = submission
                self.delegate?.retrievedSubmission()
            case .failure(let error):
                print(error)
            }
        }
    }

    func deleteButtonTapped() {
        guard let record = record else { return }

        sessionProvider.request(type: Submission.self, service: QstreakService.deleteSubmission(date: record.dateString)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.delegate?.submissionDeletionSuccess()
            case .failure(let error):
                self.delegate?.submissionDeletionFailure(error: error)
            }
        }
    }
}
