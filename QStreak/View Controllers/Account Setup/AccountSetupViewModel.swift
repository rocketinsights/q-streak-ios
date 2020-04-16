//
//  AccountSetupViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol AccountSetupViewModelDelegate: AnyObject {
    func showRecordListViewController()
}

class AccountSetupViewModel {

    private let sessionProvider = URLSessionProvider()

    weak var delegate: AccountSetupViewModelDelegate?

    func continueButtonTapped(zipCode: String?, ageString: String?, householdSizeString: String?) {
        guard
            let zipCode = zipCode,
            let ageString = ageString,
            let age = Int(ageString),
            let householdSizeString = householdSizeString,
            let householdSize = Int(householdSizeString)
            else { return }

        sessionProvider.request(type: User.self, service: QstreakService.signUp(age: age, householdSize: householdSize, zipCode: zipCode)) { [weak self] result in
            switch result {
            case let .success(user):
                UserDefaults.standard.set(user.uuid, forKey: "uuid")
                DispatchQueue.main.async {
                    self?.delegate?.showRecordListViewController()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}
