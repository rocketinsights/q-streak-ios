//
//  AccountSetupViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol AccountSetupViewModelDelegate: AnyObject {
    func showDashboardViewController()
    func failedRequest(error: NetworkError)
    func retrievedAccount()
}

class AccountSetupViewModel {

    let alertTitleText = "Unable to create account"
    let alertDismissButtonText =  "OK"

    var account: User?

    private let sessionProvider = URLSessionProvider()

    weak var delegate: AccountSetupViewModelDelegate?

    init() {
        getAccount()
    }

    func getAccount() {
        sessionProvider.request(type: User.self, service: QstreakService.getAccount) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let account):
                self.account = account
            case .failure:
                break
            }

            self.delegate?.retrievedAccount()
        }
    }

    func updateAccount(name: String?, zipCode: String?) {
        guard let zipCode = zipCode else { return }

        sessionProvider.request(type: User.self, service: QstreakService.updateAccount(zipCode: zipCode, name: name)) { [weak self] result in
            switch result {
            case .success(let user):
                if user != nil {
                    DispatchQueue.main.async {
                        self?.delegate?.showDashboardViewController()
                    }
                }
            case .failure(let error):
                self?.delegate?.failedRequest(error: error)
            }
        }
    }

    func continueButtonTapped(name: String?, zipCode: String?) {
        guard let zipCode = zipCode else { return }

        sessionProvider.request(type: User.self, service: QstreakService.signUp(name: name, zipCode: zipCode)) { [weak self] result in
            switch result {
            case .success(let user):
                if let user = user {
                    UserDefaults.standard.set(user.uuid, forKey: "uuid")
                    DispatchQueue.main.async {
                        self?.delegate?.showDashboardViewController()
                    }
                }
            case .failure(let error):
                self?.delegate?.failedRequest(error: error)
            }
        }
    }
}
