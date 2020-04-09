//
//  RecordDetailViewController.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var recordDateLabel: UILabel!

    @IBOutlet weak var contactCountLabel: UILabel!

    @IBOutlet weak var activityLabel: UILabel!

    // MARK: - Properties

    var recordToEdit: Record?

    private let viewModel = RecordDetailViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let record = recordToEdit {
            recordDateLabel.text = String(Date.getFormattedDate(date: record.creationDate, format: "yyyy-MM-dd"))
            contactCountLabel.text = String(record.contactCount)
            activityLabel.text = record.activities.map { $0.name }.joined(separator: ", ")
        }
    }
}

extension Date {
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}
