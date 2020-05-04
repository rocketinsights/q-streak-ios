//
//  AccountSetupViewController.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class AccountSetupViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var zipCodeTextField: QTextField!

    @IBOutlet private weak var userNameTextField: QTextField!

    @IBOutlet private weak var continueButton: QButton!

    // MARK: - Properties

    private let viewModel = AccountSetupViewModel()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - IBAction

    @IBAction private func continueButtonTapped(_ sender: Any) {
        viewModel.continueButtonTapped(name: userNameTextField.text, zipCode: zipCodeTextField.text)
    }

}

extension AccountSetupViewController: AccountSetupViewModelDelegate {

    func showDashboardViewController() {
        let dashboardViewStoryboard = UIStoryboard(name: String(describing: DashboardViewController.self), bundle: nil)
        let dashboardViewController = dashboardViewStoryboard.instantiateViewController(withIdentifier: String(describing: DashboardViewController.self))

        navigationController?.pushViewController(dashboardViewController, animated: true)
    }

    func failedAccountCreation(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
