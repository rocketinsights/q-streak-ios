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

    func continueButtonTapped(name: String?, zipCode: String?) {
        guard let zipCode = zipCode else { return }

        sessionProvider.request(type: User.self, service: QstreakService.signUp(name: name, zipCode: zipCode)) { [weak self] result in
            switch result {
            case .success(let user):
                if let user = user {
                    UserDefaults.standard.set(user.uuid, forKey: "uuid")
                    DispatchQueue.main.async {
                        self?.delegate?.showAddRecordViewController()
                    }
                }
            case .failure(let error):
                self?.delegate?.failedAccountCreation(error: error)
            }
        }
    }
}
