//
//  DashboardViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/29/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

    @IBOutlet private weak var activityLogTitleLabel: UILabel!

    @IBOutlet private weak var lastTwoWeeksLabel: UILabel!

    @IBOutlet private weak var viewHistoryButton: UIButton!

    @IBOutlet private weak var scoreButton: UIButton!

    @IBOutlet private weak var greetingLabel: UILabel!

    @IBOutlet private weak var placeholderView1: UIView!

    @IBOutlet private weak var placeholderView2: UIView!

    @IBOutlet private weak var recordActivityView: UIView!

    // MARK: - Properties

    private let viewModel = DashboardViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setUpCollectionView()
        setUpPlaceholderViews()
        setUpRecordActivityView()
    }

    // MARK: IBActions

    @IBAction func viewHistoryButtonTapped(_ sender: Any) {
    }

    // MARK: - Methods

    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }

    private func setUpPlaceholderViews() {
        let borderColor = UIColor(red: 63 / 255, green: 61 / 255, blue: 86 / 255, alpha: 0.2).cgColor
        placeholderView1.clipsToBounds = true
        placeholderView1.layer.cornerRadius = 11
        placeholderView1.layer.borderWidth = 1
        placeholderView1.layer.borderColor = borderColor

        placeholderView2.clipsToBounds = true
        placeholderView2.layer.cornerRadius = 11
        placeholderView2.layer.borderWidth = 1
        placeholderView2.layer.borderColor = borderColor
    }

    private func setUpRecordActivityView() {
        recordActivityView.layer.cornerRadius = 20
        recordActivityView.layer.shadowColor = UIColor(red: 213 / 255, green: 214 / 255, blue: 219 / 255, alpha: 0.3).cgColor
        recordActivityView.layer.shadowOpacity = 1
        recordActivityView.layer.shadowOffset = CGSize(width: 0, height: 0)
        recordActivityView.layer.shadowRadius = 10
        recordActivityView.layer.shadowPath = UIBezierPath(rect: recordActivityView.bounds).cgPath
    }
}

// MARK: - DashboardViewModelDelegate

extension DashboardViewController: DashboardViewModelDelegate {

    func submissionsUpdated() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.submissionsToShow.count - 1, section: 0), at: .right, animated: false)

            let scoreImage: UIImage?
            switch self.viewModel.score {
            case 1...5:
                scoreImage = UIImage(named: "Score\(self.viewModel.score)")
            default:
                scoreImage = UIImage(named: "noScore")
            }
            self.scoreButton.setBackgroundImage(scoreImage, for: .normal)
        }
    }

    func userUpdated(_ user: User) {
        DispatchQueue.main.async {
            if let firstName = user.name?.components(separatedBy: .whitespaces).first?.capitalized {
                self.greetingLabel.text = "Thanks For Tracking, \(firstName)!"
            } else {
                self.greetingLabel.text = "Thanks For Tracking!"
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension DashboardViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.submissionsToShow.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityLogCell", for: indexPath) as? ActivityLogCollectionViewCell else { return UICollectionViewCell() }

        if indexPath.item == viewModel.submissionsToShow.count - 1,
            viewModel.submissionsToShow[indexPath.item] == nil {
            cell.completionStatusImageView.image = UIImage(named: "fadedCheck")
        } else if viewModel.submissionsToShow[indexPath.item] != nil {
            cell.completionStatusImageView.image = UIImage(named: "greenCheck")
        } else {
            cell.completionStatusImageView.image = UIImage(named: "emptyCheck")
        }

        let dayStrings = viewModel.getDayAndDayNumber(at: indexPath.item)
        cell.dayLabel.text = dayStrings?.day.uppercased()
        cell.dayNumberLabel.text = "\(dayStrings?.dayNumber ?? 0)"

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DashboardViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 36, height: 70)
    }
}
