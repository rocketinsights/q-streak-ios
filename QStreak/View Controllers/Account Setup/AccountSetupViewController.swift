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
    }

    // MARK: - IBAction

    @IBAction private func continueButtonTapped(_ sender: Any) {
        viewModel.continueButtonTapped(zipCode: zipCodeTextField.text, ageString: ageTextField.text, householdSizeString: householdSizeTextField.text)
    }
}

extension AccountSetupViewController: AccountSetupViewModelDelegate {

    func showRecordListViewController() {
        let recordListStoryboard = UIStoryboard(name: String(describing: RecordListViewController.self), bundle: nil)
        let recordListViewController = recordListStoryboard.instantiateViewController(withIdentifier: String(describing: RecordListViewController.self))
        navigationController?.pushViewController(recordListViewController, animated: true)
    }
}
