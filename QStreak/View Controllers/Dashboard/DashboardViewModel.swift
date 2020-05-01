//
//  DashboardViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/29/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol DashboardViewModelDelegate: AnyObject {
    func submissionsUpdated()
    func userUpdated(_ user: User)
}

class DashboardViewModel {

    // MARK: - Properties

    var submissionsToShow = [Submission?]()

    private var submissions = [Submission]()

    private let sessionProvider = URLSessionProvider()

    weak var delegate: DashboardViewModelDelegate?

    var score = 0

    // MARK: - Initializers

    init() {
        fetchSubmissions()
        fetchUser()
    }

    // MARK: - Methods

    func fetchSubmissions() {
        sessionProvider.request(type: PagedSubmissions.self, service: QstreakService.getSubmissions(page: 1, pageSize: 14)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if let response = response {
                    self.submissions = response.records
                    self.prepareCollectionView()
                    self.updateScore()
                    self.delegate?.submissionsUpdated()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func prepareCollectionView() {
        let currentDate = Date()
        guard let collectionViewStartDate = Calendar.current.date(byAdding: .weekOfYear, value: -2, to: currentDate) else { return }
        let submissions = self.submissions.filter {
            if let date = Date.date(for: $0.dateString) {
                return date > collectionViewStartDate
            }
            return false
        }

        var submissionsToShow: [Submission?] = Array(repeating: nil, count: 14)

        submissions.forEach {
            if let submissionDate = Date.date(for: $0.dateString) {
                let dateComponents = Calendar.current.dateComponents([.day], from: submissionDate, to: currentDate)
                if let days = dateComponents.day,
                    days >= 0,
                    days < submissionsToShow.count {
                    submissionsToShow[days] = $0
                }
            }
        }
        self.submissionsToShow = submissionsToShow.reversed()
    }

    func getDayAndDayNumber(at submissionIndex: Int) -> (day: String, dayNumber: Int)? {
        guard
            let date = Calendar.current.date(byAdding: .day, value: submissionIndex - 13, to: Date()),
            let weekday = Calendar.current.dateComponents([.weekday, .day], from: date).weekday,
            let dayNumber = Calendar.current.dateComponents([.weekday, .day], from: date).day
            else { return nil }

        let day = Calendar.current.shortWeekdaySymbols[weekday - 1]

        return (day, dayNumber)
    }

    private func updateScore() {
        guard
            let submission = submissions.first,
            let submissionDate = Date.date(for: submission.dateString),
            Calendar.current.isDateInToday(submissionDate)
            else { return }

        score = submission.score
    }

    private func fetchUser() {
        sessionProvider.request(type: User.self, service: QstreakService.getUser) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let user):
                if let user = user {
                    self.delegate?.userUpdated(user)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
