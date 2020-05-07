//
//  ScoreModalController.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/6/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

protocol AboutScoreViewControllerDelegate: AnyObject {
    func dismissButtonTapped(_ aboutScoreViewController: AboutScoreViewController)
}

class AboutScoreViewController: UIViewController {

    weak var delegate: AboutScoreViewControllerDelegate?

    @IBAction func gotItButtonTapped(_ sender: Any) {
        delegate?.dismissButtonTapped(self)
    }
}
