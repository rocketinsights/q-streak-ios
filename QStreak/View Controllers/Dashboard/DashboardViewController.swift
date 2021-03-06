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

    @IBOutlet private weak var userAccountButton: UIButton!

    @IBOutlet private weak var dashboardMessage1View: UIView!

    @IBOutlet private weak var dashboardMessage1Icon: UILabel!

    @IBOutlet private weak var dashboardMessage1Header: UILabel!

    @IBOutlet weak var dashboardMessage1Body: UILabel!

    @IBOutlet private weak var dashboardMessage2View: UIView!

    @IBOutlet private weak var dashboardMessage2Icon: UILabel!

    @IBOutlet private weak var dashboardMessage2Header: UILabel!

    @IBOutlet private weak var dashboardMessage2Body: UILabel!

    @IBOutlet private weak var hazardMessageLabel: UILabel!

    @IBOutlet private weak var recordActivityView: UIView!

    // MARK: - Properties

    private let viewModel = DashboardViewModel()

    private var isInitialLoad = true

    //swiftlint:disable weak_delegate
    private let cardTransitioningDelegate = CardTransitioningDelegate()
    //swiftlint:enable weak_delegate

    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        return blurView
    }()

    private let indigo = UIColor(red: 0.42, green: 0.39, blue: 1.00, alpha: 1.00)

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setUpCollectionView()
        setupDashboardMessageViews()
        setUpRecordActivityView()
        setUpBlurView()
        setupGreetingLabel()
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

        aboutScoreViewController.transitioningDelegate = cardTransitioningDelegate
        aboutScoreViewController.modalPresentationStyle = .custom
        (aboutScoreViewController as? AboutScoreViewController)?.delegate = self

        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }

            self.blurView.alpha = 0.95
            self.present(aboutScoreViewController, animated: true)
        }
    }

    @IBAction func userAccountButtonTapped(_ sender: Any) {
        showUserAccountViewController()
    }

    @objc func greetingLabelTapped(_ sender: UITapGestureRecognizer) {
        showUserAccountViewController()
    }

    @objc func dashboardMessage1ViewTapped(_ sender: UITapGestureRecognizer) {
        if let urlString = self.viewModel.dashboardData?.dashboardMessages[0].url {
            if let url = makeValidURL(from: urlString) {
                UIApplication.shared.open(url)
            }
        }
    }

    @objc func dashboardMessage2ViewTapped(_ sender: UITapGestureRecognizer) {
        if let urlString = self.viewModel.dashboardData?.dashboardMessages[1].url {
            if let url = makeValidURL(from: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    private func makeValidURL(from potentialURL: String?) -> URL? {
        guard let urlString = potentialURL else { return nil }
        if urlString.hasPrefix("https://") || urlString.hasPrefix("http://") {
            return URL(string: urlString)
        } else {
            let correctedURL = "http://\(urlString)"
            return URL(string: correctedURL)
        }
    }

    // MARK: - Methods

    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
    }

    private func setupDashboardMessageViews() {
        let borderColor = UIColor(red: 63 / 255, green: 61 / 255, blue: 86 / 255, alpha: 0.2).cgColor
        dashboardMessage1View.clipsToBounds = true
        dashboardMessage1View.layer.cornerRadius = 11
        dashboardMessage1View.layer.borderWidth = 1
        dashboardMessage1View.layer.borderColor = borderColor
        dashboardMessage1View.isUserInteractionEnabled = true

        dashboardMessage1Icon.font = UIFont(name: "Font Awesome 5 Free", size: 24)

        dashboardMessage2View.clipsToBounds = true
        dashboardMessage2View.layer.cornerRadius = 11
        dashboardMessage2View.layer.borderWidth = 1
        dashboardMessage2View.layer.borderColor = borderColor
        dashboardMessage2View.isUserInteractionEnabled = true

        dashboardMessage2Icon.font = UIFont(name: "Font Awesome 5 Free", size: 24)
    }

    private func setUpRecordActivityView() {
        recordActivityView.layer.cornerRadius = 20
        recordActivityView.layer.shadowColor = UIColor(red: 213 / 255, green: 214 / 255, blue: 219 / 255, alpha: 0.3).cgColor
        recordActivityView.layer.shadowOpacity = 1
        recordActivityView.layer.shadowOffset = CGSize(width: 0, height: 0)
        recordActivityView.layer.shadowRadius = 10
        recordActivityView.layer.shadowPath = UIBezierPath(rect: recordActivityView.bounds).cgPath
    }

    private func setUpBlurView() {
        view.addSubview(blurView)
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupGreetingLabel() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.greetingLabelTapped(_:)))
        self.greetingLabel.isUserInteractionEnabled = true
        self.greetingLabel.addGestureRecognizer(labelTap)
    }

    private func showAddRecordViewController() {
        if let addRecordViewController = AddRecordViewController.initialize(viewModel: AddRecordViewModel()) {
            addRecordViewController.presentationController?.delegate = self
            present(addRecordViewController, animated: true, completion: nil)
        }
    }

    private func showUserAccountViewController() {
        if let userAccount = viewModel.userAccount {
            let viewAccountModel = ViewAccountModel(account: userAccount)

            if let viewAccountController = ViewAccountController.initialize(viewModel: viewAccountModel) {
                navigationController?.pushViewController(viewAccountController, animated: true)
            }
        }
    }

    private func constructDashboardMessageBodyText(dashboardMessage: DashboardMessage) -> NSMutableAttributedString {
        let message = dashboardMessage.body
        let attributedString = NSMutableAttributedString(string: message)

        guard dashboardMessage.url != nil else { return attributedString }

        let linkRange =  NSRange(location: 0, length: message.count)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: linkRange)
        return attributedString
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
                self.greetingLabel.text = "Hello, \(firstName)!"
            } else {
                self.greetingLabel.text = "Hello!"
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

    func dashboardDataUpdated(dashboardData: DashboardData) {
        DispatchQueue.main.async {
            let countyName = dashboardData.dailyStats.location.county
            self.hazardMessageLabel.text = "\(countyName) is at risk for continued outbreaks."

            guard dashboardData.dashboardMessages.count > 0 else { return }
            let message1 = dashboardData.dashboardMessages[0]
            self.dashboardMessage1Header.text = message1.title
            self.dashboardMessage1Body.attributedText = self.constructDashboardMessageBodyText(dashboardMessage: message1)
            self.dashboardMessage1Icon.text =  FontAwesomeUtils().stringToUnicode(icon: message1.icon)

            if message1.url != nil {
                let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.dashboardMessage1ViewTapped(_:)))
                self.dashboardMessage1View.addGestureRecognizer(labelTap)
            }

            guard dashboardData.dashboardMessages.count > 1 else { return }
            let message2 = dashboardData.dashboardMessages[1]
            self.dashboardMessage2Header.text = message2.title
            self.dashboardMessage2Body.attributedText = self.constructDashboardMessageBodyText(dashboardMessage: message2)
            self.dashboardMessage2Icon.text = FontAwesomeUtils().stringToUnicode(icon: message2.icon)

            if message2.url != nil {
                let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.dashboardMessage2ViewTapped(_:)))
                self.dashboardMessage2View.addGestureRecognizer(labelTap)
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

// MARK: - UIAdaptivePresentationControllerDelegate

extension DashboardViewController: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.viewModel.fetchSubmissions()
    }
}

// MARK: AboutScoreViewControllerDelegate

extension DashboardViewController: AboutScoreViewControllerDelegate {

    func dismissButtonTapped(_ aboutScoreViewController: AboutScoreViewController) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }

            self.blurView.alpha = 0
            aboutScoreViewController.dismiss(animated: true)
        }
    }
}
