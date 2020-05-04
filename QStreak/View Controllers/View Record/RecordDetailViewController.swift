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

        viewModel.delegate = self
        setupNavbar()
        setupViews()
    }

    @IBAction private func deleteButtonTapped(_ sender: Any) {
        viewModel.deleteButtonTapped()
    }

    private func setupViews() {
        setSubmissionDateLabel()
        setContactLabel()
        setRatingImage()
        setupTableView()
    }
    
    private func setupNavbar() {
        navigationController?.navigationBar.isHidden = true
    }

    func redirectToDashboard() {
        DispatchQueue.main.async {
             let dashboardStoryboard = UIStoryboard(name: String(describing: DashboardViewController.self), bundle: nil)
             let dashboardViewController = dashboardStoryboard.instantiateViewController(withIdentifier: String(describing: DashboardViewController.self))
             self.navigationController?.pushViewController(dashboardViewController, animated: true)
        }
    }

    private func setRatingImage() {
        // TODO: fix this once API is updated
        switch (self.viewModel.record.score ?? 0) {
        case 1...5:
            submissionRatingImage.image = UIImage(named: "Score\(String(describing: self.viewModel.record.score))Large")
        default:
            submissionRatingImage.image = UIImage(named: "noScoreLarge")
        }
    }

    private func setContactLabel() {
        if viewModel.record.contactCount < 1 {
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
        tableView.rowHeight = 44
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension RecordDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.record.destinations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: "recordActivitiesCell", for: indexPath) as! SubmissionActivityCell
        // swiftlint:enable force_cast

        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.25, green: 0.24, blue: 0.34, alpha: 0.20).cgColor

        cell.activityLabel?.text = viewModel.record.destinations[indexPath.row]?.name
        cell.activityIcon.font = UIFont(name: "Font Awesome 5 Free", size: 18)
        cell.activityIcon.text = "\u{f0f4}"

        return cell
    }
}

extension RecordDetailViewController: RecordDetailViewModelDelegate {
    func submissionDeletionSuccess() {
        redirectToDashboard()
    }

    func submissionDeletionFailure(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
