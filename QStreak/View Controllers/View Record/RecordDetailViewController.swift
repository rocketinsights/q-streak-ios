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

    @IBOutlet private weak var totalCasesLabel: UILabel!

    @IBOutlet private weak var totalDeathsLabel: UILabel!

    @IBOutlet private weak var dailyStatsDateLabel: UILabel!
    
    @IBOutlet weak var quarantineScoreLabel: UILabel!
    
    @IBOutlet weak var riskLevelLabel: UILabel!

    // MARK: - Properties

    var viewModel: RecordDetailViewModel!

    // MARK: - Life Cycle

    static func initialize(viewModel: RecordDetailViewModel) -> RecordDetailViewController? {
        let recordDetailStoryboard = UIStoryboard(name: String(describing: RecordDetailViewController.self), bundle: nil)
        let viewController = recordDetailStoryboard.instantiateViewController(identifier: "RecordDetailViewController") as? RecordDetailViewController

        viewController?.viewModel = viewModel

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        recordDateLabel.text = viewModel.record.dateString
        contactCountLabel.text = String(viewModel.record.contactCount)
        dailyStatsDateLabel.text = viewModel.record.dailyStats.date
        totalCasesLabel.text = String(viewModel.record.dailyStats.cases)
        totalDeathsLabel.text = String(viewModel.record.dailyStats.deaths)
        quarantineScoreLabel.text = String(viewModel.record.score)
        riskLevelLabel.text = String(viewModel.record.dailyStats.riskLevel)
        activityLabel.text = viewModel.record.destinations
                                .map { $0.name }
                                .joined(separator: ", ")

    }
}
