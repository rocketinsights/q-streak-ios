//
//  ViewAccountController.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/12/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class ViewAccountController: UIViewController {

    @IBOutlet private weak var editButton: UIButton!

    @IBOutlet private weak var pageHeaderLabel: UILabel!

    @IBOutlet private weak var nameView: UIView!

    @IBOutlet private weak var nameValueLabel: UILabel!

    @IBOutlet private weak var zipCodeView: UIView!

    @IBOutlet private weak var zipCodeValueLabel: UILabel!

    @IBOutlet private weak var editNameButton: UIButton!

    @IBOutlet private weak var editNameButtonWidthConstraint: NSLayoutConstraint!

    @IBOutlet private weak var editZipCodeButton: UIButton!

    @IBOutlet private weak var editZipCodeButtonWidthConstraint: NSLayoutConstraint!

    private let grey = UIColor(red: 0.95, green: 0.96, blue: 0.97, alpha: 1.00)

    var viewModel: ViewAccountModel!

    var editingUserAccount = false

    static func initialize(viewModel: ViewAccountModel) -> ViewAccountController? {
        let viewControllerStoryboard = UIStoryboard(name: String(describing: ViewAccountController.self), bundle: nil)
        let viewController = viewControllerStoryboard.instantiateViewController(identifier: "ViewAccountController") as? ViewAccountController

        viewController?.viewModel = viewModel

        return viewController
    }

    @IBAction func editAccountButtonTapped(_ sender: Any) {
        self.editingUserAccount = !self.editingUserAccount

        if self.editingUserAccount == true {
            editButton.setTitle("Done", for: .normal)
            pageHeaderLabel.text = "Edit Profile"
            editNameButton.isHidden = false
            editNameButtonWidthConstraint.constant = 15
            editZipCodeButton.isHidden = false
            editZipCodeButtonWidthConstraint.constant = 15
        } else {
            editButton.setTitle("Edit", for: .normal)
            pageHeaderLabel.text = "Profile"
            editNameButton.isHidden = true
            editNameButtonWidthConstraint.constant = 0
            editZipCodeButton.isHidden = true
            editZipCodeButtonWidthConstraint.constant = 0
        }
    }

    @IBAction func editNameButtonTapped(_ sender: Any) {
        let editAccountFieldViewModel = EditAccountFieldModel(account: viewModel.account, pageTitle: "Edit User Name", fieldName: "name")

        if let editAccountFieldController = EditAccountFieldController.initialize(viewModel: editAccountFieldViewModel) {

            editAccountFieldController.parentViewControllerDelegate = self

            navigationController?.pushViewController(editAccountFieldController, animated: true)
        }
    }

    @IBAction func editZipCodeButton(_ sender: Any) {
        let editAccountFieldViewModel = EditAccountFieldModel(account: viewModel.account, pageTitle: "Edit Zip Code", fieldName: "zipCode")

        if let editAccountFieldController = EditAccountFieldController.initialize(viewModel: editAccountFieldViewModel) {
            editAccountFieldController.parentViewControllerDelegate = self

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

    func accountUpdated() {
        setupAccountValueViews()
    }

    private func setupViews() {
        setupEditViews()
        setupAccountValueViews()
    }

    private func setupAccountValueViews() {
        DispatchQueue.main.async {
            self.nameValueLabel.text = self.viewModel.account.name
            self.zipCodeValueLabel.text = self.viewModel.account.zipCode
        }
    }

    private func setupEditViews() {
        editNameButton.isHidden = true
        editNameButtonWidthConstraint.constant = 0
        editZipCodeButton.isHidden = true
        editZipCodeButtonWidthConstraint.constant = 0
    }
}
