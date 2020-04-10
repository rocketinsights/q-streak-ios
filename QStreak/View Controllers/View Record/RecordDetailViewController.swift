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

    @IBOutlet private weak var recordDateLabel: UILabel!

    @IBOutlet private weak var contactCountLabel: UILabel!

    @IBOutlet private weak var activityLabel: UILabel!

    // MARK: - Properties

    var record: Record?

    private let viewModel = RecordDetailViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        if let record = record {
            // TODO: - use viewModel
            recordDateLabel.text = record.creationDate.formattedDate
            contactCountLabel.text = String(record.contactCount)
            activityLabel.text = record.activities.map { $0.name }.joined(separator: ", ")
        }
    }
}
