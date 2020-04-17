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

    var dashboardButton: UIBarButtonItem!

    var viewModel: RecordDetailViewModel!

    var comingFromCreation = true

    // MARK: - Life Cycle

    static func initialize(viewModel: RecordDetailViewModel, comingFromCreation: Bool) -> RecordDetailViewController? {
        let recordDetailStoryboard = UIStoryboard(name: String(describing: RecordDetailViewController.self), bundle: nil)
        let viewController = recordDetailStoryboard.instantiateViewController(identifier: "RecordDetailViewController") as? RecordDetailViewController

        viewController?.viewModel = viewModel

        viewController?.comingFromCreation = comingFromCreation

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupViews()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(false, animated: false)
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

    private func setupNavBar() {
        if comingFromCreation {
            // Make sure we always go back to the RecordListViewController
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.navigationItem.setHidesBackButton(true, animated: false)
            self.dashboardButton = UIBarButtonItem(title: "Dashboard", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backToDashboard(sender:)))
            self.navigationItem.rightBarButtonItem = self.dashboardButton
        }
    }

    @objc private func backToDashboard(sender: UIBarButtonItem) {
        let recordListStoryboard = UIStoryboard(name: String(describing: RecordListViewController.self), bundle: nil)
        let recordListViewController = recordListStoryboard.instantiateViewController(withIdentifier: String(describing: RecordListViewController.self))
        self.navigationController?.pushViewController(recordListViewController, animated: true)
    }
}
