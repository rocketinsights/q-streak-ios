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
    func addedSubmission(_ submission: Submission)
    func failedSubmission(error: NetworkError)
    func retrievedSubmission()
}

class AddRecordViewModel {

    // MARK: - Properties

    let alertTitleText = "Unable to create submission"

    let alertDismissButtonText =  "OK"

    let infoText = "📉 Let’s get your score calculated for the day. You can return here at any time to update your daily input."

    private let sessionProvider = URLSessionProvider()

    weak var delegate: AddRecordViewModelDelegate?

    var categories = [Activity]()

    var submissionDate: Date {
        didSet {
            getSubmission()
        }
    }

    var submission: Submission?

    var currentContactCount: Int = 0

    // MARK: Initializers

    init(date: Date = Calendar.current.startOfDay(for: Date())) {
        submissionDate = date

        getSubmission()
        getDestinations()
    }

    // MARK: - Methods

    func saveButtonTapped(selectedIndexPaths: [IndexPath]?) {
        var destinations = [String]()

        if let selectedIndexPaths = selectedIndexPaths {
            destinations = selectedIndexPaths.map { categories[$0.row].slug }
        }

        if submission != nil {
            updateSubmission(destinations: destinations)
        } else {
            addSubmission(destinations: destinations)
        }
    }

    func isContactCountValid(contactCountString: String?) -> Bool {
        guard
            let contactCountString = contactCountString,
            let contactCount = Int(contactCountString)
            else { return false }

        return contactCount > 0 ? true : false
    }

    func decrementedContactCount() {
        guard currentContactCount > 0 else { return }
        currentContactCount -= 1
    }

    func incrementedContactCount() {
        currentContactCount += 1
    }

    func setContactCount(_ contactCountString: String?) {
        guard
            let contactCountString = contactCountString,
            let contactCount = Int(contactCountString)
            else {
                currentContactCount = 0
                return
            }
        currentContactCount = contactCount
    }

    private func getDestinations() {
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

    private func getSubmission() {
        submission = nil
        currentContactCount = 0
        sessionProvider.request(type: Submission.self, service: QstreakService.getSubmission(date: submissionDate.formattedDate(dateFormat: "yyyy-MM-dd"))) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let submission):
                if let submission = submission {
                    self.submission = submission
                    self.currentContactCount = submission.contactCount
                }
            case .failure:
                break
            }
            self.delegate?.retrievedSubmission()
        }
    }

    private func updateSubmission(destinations: [String]) {
        guard let submission = submission else { return }

        sessionProvider.request(type: Submission.self, service: QstreakService.updateSubmission(contactCount: currentContactCount, date: submission.dateString, destinations: destinations)) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let submission):
                if let submission = submission {
                    self.delegate?.addedSubmission(submission)
                }
            case .failure(let error):
                self.delegate?.failedSubmission(error: error)
            }
        }
    }

    private func addSubmission(destinations: [String]) {
        sessionProvider.request(type: Submission.self, service: QstreakService.createSubmission(contactCount: currentContactCount, date: submissionDate.formattedDate(dateFormat: "yyyy-MM-dd"), destinations: destinations)) { [weak self ] result in
            guard let self = self else { return }

            switch result {
            case .success(let submission):
                if let submission = submission {
                    self.delegate?.addedSubmission(submission)
                }
            case .failure(let error):
                self.delegate?.failedSubmission(error: error)
            }
        }
    }
}
