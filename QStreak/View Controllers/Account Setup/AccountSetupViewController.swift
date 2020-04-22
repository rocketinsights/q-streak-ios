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

    @IBOutlet private weak var ageTextField: UITextField!

    @IBOutlet private weak var householdSizeTextField: UITextField!

    @IBOutlet private weak var continueButton: UIButton!

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
        viewModel.continueButtonTapped(zipCode: zipCodeTextField.text, ageString: ageTextField.text, householdSizeString: householdSizeTextField.text)
    }

}

extension AccountSetupViewController: AccountSetupViewModelDelegate {

    func showAddRecordViewController() {
        let addRecordStoryboard = UIStoryboard(name: String(describing: AddRecordViewController.self), bundle: nil)
        let addRecordViewController = addRecordStoryboard.instantiateViewController(withIdentifier: String(describing: AddRecordViewController.self))

        navigationController?.pushViewController(addRecordViewController, animated: true)
    }

    func failedAccountCreation(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Request Unsuccessful", message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
