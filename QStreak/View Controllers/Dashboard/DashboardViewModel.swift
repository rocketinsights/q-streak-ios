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
}

class DashboardViewModel {

    // MARK: - Properties

    var submissionsToShow = [Submission?]()

    private var submissions = [Submission]()

    private let sessionProvider = URLSessionProvider()

    weak var delegate: DashboardViewModelDelegate?

    // MARK: - Initializers

    init() {
        fetchSubmissions()
    }

    // MARK: - Methods

    func fetchSubmissions() {
        sessionProvider.request(type: PagedSubmissions.self, service: QstreakService.getSubmissions(page: 1, pageSize: 14)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(response):
                self.submissions = response.records
                self.prepareCollectionView()
            case let .failure(error):
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
        delegate?.submissionsUpdated()
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
}
