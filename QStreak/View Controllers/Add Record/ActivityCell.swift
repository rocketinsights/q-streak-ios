//
//  ActivityCell.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/4/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityCellImage: UIImageView!

    @IBOutlet weak var activityCellLabel: UILabel!

    func setImageAs(imageName: String) {
        activityCellImage.image = UIImage(named: imageName)
    }
}
