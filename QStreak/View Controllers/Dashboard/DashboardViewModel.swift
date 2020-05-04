//
//  DashboardViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/29/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

protocol DashboardViewModelDelegate: AnyObject {
    func submissionsUpdated()
    func userUpdated(_ user: User)
    func showSubmissionDetail(for submission: Submission)
    func showAddSubmission(for date: Date)
}

class DashboardViewModel {

    // MARK: - Properties

    var submissionsToShow = [Submission?]()

    private var submissions = [Submission]()

    private let sessionProvider = URLSessionProvider()

    weak var delegate: DashboardViewModelDelegate?

    var score = 0

    let calendar = Calendar.current

    private var numberOfDaysInWeek: Int {
        return calendar.range(of: .weekday, in: .weekOfYear, for: calendar.startOfDay(for: Date()))?.count ?? 0
    }

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
        let days = getCollectionViewDates()

        guard let collectionViewStartDate = days.first else { return }

        let submissions = self.submissions.filter {
            if let date = Date.date(for: $0.dateString) {
                let submissionDate = calendar.startOfDay(for: date)
                return submissionDate >= collectionViewStartDate
            }
            return false
        }

        var submissionsToShow: [Submission?] = Array(repeating: nil, count: numberOfDaysInWeek * 2)

        submissions.forEach {
            if let date = Date.date(for: $0.dateString) {
                let submissionDate = calendar.startOfDay(for: date)
                let dateComponents = calendar.dateComponents([.day], from: collectionViewStartDate, to: submissionDate)
                if let days = dateComponents.day,
                    days >= 0,
                    days < submissionsToShow.count {
                    submissionsToShow[days] = $0
                }
            }
        }
        self.submissionsToShow = submissionsToShow
    }

    func getDayAndDayNumber(at submissionIndex: Int) -> (day: String, dayNumber: Int)? {
        let days = getCollectionViewDates()

        guard
            let collectionViewStartDate = days.first,
            let date = calendar.date(byAdding: .day, value: submissionIndex, to: collectionViewStartDate),
            let weekday = calendar.dateComponents([.weekday, .day], from: date).weekday,
            let dayNumber = calendar.dateComponents([.weekday, .day], from: date).day
            else { return nil }

        let day = calendar.shortWeekdaySymbols[weekday - 1]

        return (day, dayNumber)
    }

    private func getCollectionViewDates() -> [Date] {
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)

        guard let weekdays = calendar.range(of: .weekday, in: .weekOfYear, for: today) else { return [] }

        return ((weekdays.lowerBound - weekdays.count) ..< weekdays.upperBound)
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
    }

    func getActivityLogStatusImage(for submissionIndex: Int) -> UIImage? {
        if submissionsToShow[submissionIndex] != nil {
            return UIImage(named: "greenCheck")
        } else {
            let days = getCollectionViewDates()
            let date = days[submissionIndex]
            let today = calendar.startOfDay(for: Date())
            if date > today {
                return UIImage(named: "emptyCheck")
            }
            return UIImage(named: "fadedCheck")
        }
    }

    private func updateScore() {
        guard
            let submission = submissions.first,
            let submissionDate = Date.date(for: submission.dateString),
            calendar.isDateInToday(submissionDate)
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

    func didSelectItem(for submissionIndex: Int) {
        let today = calendar.startOfDay(for: Date())
        let days = getCollectionViewDates()
        let submissionDate = days[submissionIndex]

        guard submissionDate <= today else { return }

        if let submission = submissionsToShow[submissionIndex] {
            delegate?.showSubmissionDetail(for: submission)
        } else {
            delegate?.showAddSubmission(for: submissionDate)
        }
    }
}
