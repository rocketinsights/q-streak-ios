//
//  AddRecordViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/9/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

class AddRecordViewModel {

    // MARK: - Properties

    let categories = ["Grocery Store",
                      "Post Office",
                      "Movie Theater",
                      "Concert"]

    // MARK: - Methods

    func isContactCountValid(contactCountString: String?) -> Bool {
        guard
            let contactCountString = contactCountString,
            let contactCount = Int(contactCountString)
            else { return false }

        return contactCount > 0 ? true : false
    }
}
