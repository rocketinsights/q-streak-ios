//
//  WelcomeViewController.swift
//  QStreak
//
//  Created by Clifford Anderson on 4/17/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var getStartedButton: QButton!

    // MARK: - IBAction

    @IBAction func getStartedButtonTapped(_ sender: Any) {
        guard let accountSetupViewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: AccountSetupViewController.self)) else { return }
        self.navigationController?.pushViewController(accountSetupViewController, animated: true)
    }
}
