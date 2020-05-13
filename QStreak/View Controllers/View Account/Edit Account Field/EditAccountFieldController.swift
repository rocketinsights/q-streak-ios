//
//  EditFieldController.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/12/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class EditAccountFieldController: UIViewController {

    var viewModel: EditAccountFieldModel!

    @IBOutlet weak var accountValueTextField: QTextField!

    @IBOutlet private weak var pageTitle: UILabel!

    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func saveButtonTapped(_ sender: Any) {
        viewModel.updateAccount(updatedFieldValue: accountValueTextField?.text)
    }

    static func initialize(viewModel: EditAccountFieldModel) -> EditAccountFieldController? {
        let editAccountFieldControllerStoryboard = UIStoryboard(name: String(describing: EditAccountFieldController.self), bundle: nil)
        let viewController = editAccountFieldControllerStoryboard.instantiateViewController(identifier: "EditAccountFieldController") as? EditAccountFieldController

        viewController?.viewModel = viewModel

        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        setupViews()
    }

    private func setupViews() {
        self.pageTitle.text = viewModel.pageTitle
        self.accountValueTextField.text = viewModel.fieldValue()
    }
}

extension EditAccountFieldController: EditAccountFieldModelDelegate {
    func updatedAccount() {
        DispatchQueue.main.async {
            let viewAccountModel = ViewAccountModel(account: self.viewModel.account)

            if let viewAccountController = ViewAccountController.initialize(viewModel: viewAccountModel) {
                self.navigationController?.pushViewController(viewAccountController, animated: true)
            }
        }
    }

    func failedToUpdateAccount(error: NetworkError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: self.viewModel.alertTitleText, message: error.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: self.viewModel.alertDismissButtonText, style: .default))

            self.present(alert, animated: true, completion: nil)
        }
    }
}
