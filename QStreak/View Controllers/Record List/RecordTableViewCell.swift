//
//  SubmissionTableViewCell.swift
//  QStreak
//
//  Created by Daniel McCoy on 4/15/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var submissionDateLabel: UILabel!
    @IBOutlet weak var contactCountLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        configure(with: .none)
    }

    func configure(with record: Submission?) {
      if let record = record {
        submissionDateLabel?.text = record.dateString
        contactCountLabel?.text = String(record.contactCount)
      }
    }
}
