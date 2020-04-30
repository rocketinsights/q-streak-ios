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

    @IBOutlet private weak var zipCodeTextField: UITextField!

    @IBOutlet weak var userNameTextField: QTextField!
    
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
        viewModel.continueButtonTapped(zipCode: zipCodeTextField.text, userName: userNameTextField.text)
    }

}

extension AccountSetupViewController: AccountSetupViewModelDelegate {

    func showAddRecordViewController() {
        let recordListViewStoryboard = UIStoryboard(name: String(describing: RecordListViewController.self), bundle: nil)
        let recordListViewController = recordListViewStoryboard.instantiateViewController(withIdentifier: String(describing: RecordListViewController.self))

        navigationController?.pushViewController(recordListViewController, animated: true)
    }

    func failedAccountCreation(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
