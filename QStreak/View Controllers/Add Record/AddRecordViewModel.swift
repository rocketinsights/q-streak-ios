//
//  AddRecordViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol AddRecordViewModelDelegate: AnyObject {
    func retrievedDestinations()
    func addedSubmission(record: RecordDetailViewModel)
    func failedSubmission(error: NetworkError)
}

class AddRecordViewModel {

    // MARK: - Properties

    let alertTitleText = "Unable to create submission"
    let alertDismissButtonText =  "OK"

    private let sessionProvider = URLSessionProvider()

    weak var delegate: AddRecordViewModelDelegate?

    var categories = [Activity]()

    // MARK: Initializers

    init() {
        sessionProvider.request(type: [Activity].self, service: QstreakService.getDestinations) { [weak self] result in
            switch result {
            case .success(let activities):
                if let activities = activities {
                    self?.categories = activities
                    self?.delegate?.retrievedDestinations()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    // MARK: - Methods

    func saveButtonTapped(date: Date?, contactCountString: String?, selectedIndexPaths: [IndexPath]?) {
        guard
            let date = date,
            let contactCountString = contactCountString,
            let contactCount = Int(contactCountString)
        else { return }

        var destinations = [String]()

        if let selectedIndexPaths = selectedIndexPaths {
            destinations = selectedIndexPaths.map { categories[$0.row].slug }
        }

        sessionProvider.request(type: Submission.self, service: QstreakService.createSubmission(contactCount: contactCount, date: date.formattedDate(dateFormat: "yyyy-MM-dd"), destinations: destinations)) { [weak self ] result in
            switch result {
            case .success(let submission):
                if let submission = submission {
                    let recordDetailViewModel = RecordDetailViewModel.init(record: submission)
                    self?.delegate?.addedSubmission(record: recordDetailViewModel)
                }
            case .failure(let error):
                self?.delegate?.failedSubmission(error: error)
            }
        }
    }

    func isContactCountValid(contactCountString: String?) -> Bool {
        guard
            let contactCountString = contactCountString,
            let contactCount = Int(contactCountString)
            else { return false }

        return contactCount > 0 ? true : false
    }

    func decrementedContactCount(currentCount: String) -> Int {
        return (Int(currentCount) ?? 0) - 1
    }

    func incrementedContactCount(currentCount: String) -> Int {
        return (Int(currentCount) ?? 0) + 1
    }
}
