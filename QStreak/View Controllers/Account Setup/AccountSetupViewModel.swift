//
//  AccountSetupViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol AccountSetupViewModelDelegate: AnyObject {
    func showAddRecordViewController()
    func failedAccountCreation(error: NetworkError)
}

class AccountSetupViewModel {

    let alertTitleText = "Unable to create account"
    let alertDismissButtonText =  "OK"

    private let sessionProvider = URLSessionProvider()

    weak var delegate: AccountSetupViewModelDelegate?

    func continueButtonTapped(zipCode: String?, userName: String?) {
        guard
            let zipCode = zipCode,
            let userName = userName
            else { return }

        sessionProvider.request(type: User.self, service: QstreakService.signUp(zipCode: zipCode, userName: userName)) { [weak self] result in
            switch result {
            case let .success(user):
                if let user = user {
                    UserDefaults.standard.set(user.uuid, forKey: "uuid")
                    DispatchQueue.main.async {
                        self?.delegate?.showAddRecordViewController()
                    }
                }
            case let .failure(error):
                self?.delegate?.failedAccountCreation(error: error)
            }
        }
    }
}
