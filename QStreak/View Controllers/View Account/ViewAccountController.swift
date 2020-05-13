//
//  ViewAccountController.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/12/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class ViewAccountController: UIViewController {

    @IBOutlet private weak var nameValueLabel: UILabel!

    @IBOutlet private weak var zipCodeValueLabel: UILabel!

    @IBOutlet private weak var editNameButton: UIButton!

    @IBOutlet private weak var editZipCodeButton: UIButton!

    var viewModel: ViewAccountModel!

    var editingUserAccount = false

    static func initialize(viewModel: ViewAccountModel) -> ViewAccountController? {
        let viewControllerStoryboard = UIStoryboard(name: String(describing: ViewAccountController.self), bundle: nil)
        let viewController = viewControllerStoryboard.instantiateViewController(identifier: "ViewAccountController") as? ViewAccountController

        viewController?.viewModel = viewModel

        return viewController
    }

    @IBAction func editNameButtonTapped(_ sender: Any) {
        let editAccountFieldViewModel = EditAccountFieldModel(account: viewModel.account, pageTitle: "Edit User Name", fieldName: "name")

        if let editAccountFieldController = EditAccountFieldController.initialize(viewModel: editAccountFieldViewModel) {
            navigationController?.pushViewController(editAccountFieldController, animated: true)
        }
    }

    @IBAction func editZipCodeButton(_ sender: Any) {
        let editAccountFieldViewModel = EditAccountFieldModel(account: viewModel.account, pageTitle: "Edit Zip Code", fieldName: "zipCode")

        if let editAccountFieldController = EditAccountFieldController.initialize(viewModel: editAccountFieldViewModel) {
            navigationController?.pushViewController(editAccountFieldController, animated: true)
        }
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        let dashboardViewStoryboard = UIStoryboard(name: String(describing: DashboardViewController.self), bundle: nil)
        let dashboardViewController = dashboardViewStoryboard.instantiateViewController(withIdentifier: String(describing: DashboardViewController.self))

        self.navigationController?.pushViewController(dashboardViewController, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }

    private func setupViews() {
        nameValueLabel.text = self.viewModel.account.name
        zipCodeValueLabel.text = self.viewModel.account.zipCode
    }
}
