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

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var submissionDateLabel: UILabel!

    @IBOutlet weak var submissionRatingImage: UIImageView!

    @IBOutlet weak var contactCountLabel: UILabel!

    // MARK: - Properties

    var dashboardButton: UIBarButtonItem!

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

        viewModel.delegate = self
        setupNavbar()
        setupViews()
    }

    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    @IBAction private func deleteButtonTapped(_ sender: Any) {
        viewModel.deleteButtonTapped()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    private func setupViews() {
        setSubmissionDateLabel()
        setContactLabel()
        setRatingImage()
        setupTableView()
    }
    private func setupNavbar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setRatingImage() {
        switch self.viewModel.record.score {
        case 1...5:
            submissionRatingImage.image = UIImage(named: "score\(String(describing: self.viewModel.record.score))Large")
        default:
            submissionRatingImage.image = UIImage(named: "noScoreLarge")
        }
    }

    private func setContactLabel() {
        if viewModel.record.contactCount == 1 {
            contactCountLabel.text = "\(viewModel.record.contactCount) person"
        } else {
            contactCountLabel.text = "\(viewModel.record.contactCount) people"
        }
    }

    private func setSubmissionDateLabel() {
        submissionDateLabel.text = viewModel.record.titleizedDate()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 56
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RecordDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordActivitiesCell", for: indexPath) as! SubmissionActivityCell
        // swiftlint:enable force_cast

        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.25, green: 0.24, blue: 0.34, alpha: 0.20).cgColor

        cell.activityLabel?.text = viewModel.record.destinations[indexPath.section]?.name
        cell.activityIcon.font = UIFont(name: "Font Awesome 5 Free", size: 16)
        cell.activityIcon.text = "\u{f0f4}"

        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.record.destinations.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(11)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension RecordDetailViewController: RecordDetailViewModelDelegate {
    func submissionDeletionSuccess() {
        DispatchQueue.main.async {
            let dashboardStoryboard = UIStoryboard(name: String(describing: DashboardViewController.self), bundle: nil)
            let dashboardViewController = dashboardStoryboard.instantiateViewController(withIdentifier: String(describing: DashboardViewController.self))
            self.navigationController?.pushViewController(dashboardViewController, animated: true)
        }
    }

    func submissionDeletionFailure(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
