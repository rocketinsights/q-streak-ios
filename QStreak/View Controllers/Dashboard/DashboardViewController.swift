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

    @IBOutlet private weak var scoreButton: UIButton!

    @IBOutlet private weak var greetingLabel: UILabel!

    @IBOutlet private weak var placeholderView1: UIView!

    @IBOutlet private weak var placeholderView2: UIView!

    @IBOutlet private weak var recordActivityView: UIView!

    // MARK: - Properties

    private let viewModel = DashboardViewModel()

    private var isInitialLoad = true

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setUpCollectionView()
        setUpPlaceholderViews()
        setUpRecordActivityView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: IBActions

    @IBAction func recordActivityButtonTapped(_ sender: Any) {
        showAddRecordViewController()
    }

    @IBAction func scoreButtonTapped(_ sender: Any) {
        showAddRecordViewController()
    }

    @IBAction func aboutScoreButtonTapped(_ sender: Any) {
        let aboutScoreViewStoryboard = UIStoryboard(name: String(describing: AboutScoreViewController.self), bundle: nil)
        let aboutScoreViewController = aboutScoreViewStoryboard.instantiateViewController(withIdentifier: String(describing: AboutScoreViewController.self))

        aboutScoreViewController.transitioningDelegate = self
        aboutScoreViewController.modalPresentationStyle = .custom

        present(aboutScoreViewController, animated: true, completion: nil)
    }

    // MARK: - Methods

    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
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

    private func showAddRecordViewController() {
        if let addRecordViewController = AddRecordViewController.initialize(viewModel: AddRecordViewModel()) {
            addRecordViewController.presentationController?.delegate = self
            present(addRecordViewController, animated: true, completion: nil)
        }
    }
}

// MARK: - DashboardViewModelDelegate

extension DashboardViewController: DashboardViewModelDelegate {

    func submissionsUpdated() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            if self.isInitialLoad {
                self.isInitialLoad.toggle()
                self.collectionView.scrollToItem(at: IndexPath(item: self.viewModel.submissionsToShow.count - 1, section: 0), at: .right, animated: false)
            }

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

    func showSubmissionDetail(for submission: Submission) {
        let recordDetailViewModel = RecordDetailViewModel(dateString: submission.dateString)
        if let recordDetailViewController = RecordDetailViewController.initialize(viewModel: recordDetailViewModel) {
            navigationController?.pushViewController(recordDetailViewController, animated: true)
        }
    }

    func showAddSubmission(for date: Date) {
        let addRecordViewModel = AddRecordViewModel(date: date)
        if let addRecordViewController = AddRecordViewController.initialize(viewModel: addRecordViewModel) {
            addRecordViewController.presentationController?.delegate = self
            present(addRecordViewController, animated: true, completion: nil)
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

        cell.completionStatusImageView.image = viewModel.getActivityLogStatusImage(for: indexPath.item)

        let dayStrings = viewModel.getDayAndDayNumber(at: indexPath.item)
        cell.dayLabel.text = dayStrings?.day.uppercased()
        cell.dayNumberLabel.text = "\(dayStrings?.dayNumber ?? 0)"

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(for: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension DashboardViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 7, height: 70)
    }
}

extension DashboardViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.viewModel.fetchSubmissions()
    }
}

extension DashboardViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}
