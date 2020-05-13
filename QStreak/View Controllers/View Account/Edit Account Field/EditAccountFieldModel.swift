//
//  EditAccountFieldModel.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/12/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol EditAccountFieldModelDelegate: AnyObject {
    func updatedAccount()
    func failedToUpdateAccount(error: NetworkError)
}

class EditAccountFieldModel {
    var account: User
    var pageTitle: String
    var fieldName: String

    weak var delegate: EditAccountFieldModelDelegate?

    let alertTitleText = "Unable to update submission"
    let alertDismissButtonText =  "OK"

    private let sessionProvider = URLSessionProvider()

    init(account: User, pageTitle: String, fieldName: String) {
        self.account = account
        self.pageTitle = pageTitle
        self.fieldName = fieldName
    }

    func fieldValue() -> String {
        switch fieldName {
        case "name":
            return account.name ?? ""
        case "zipCode":
            return account.zipCode
        default:
           return ""
        }
    }

    func updateAccount(updatedFieldValue: String?) {
        guard let updatedFieldValue = updatedFieldValue else { return }

        let service = QstreakService.updateAccount(
                                        zipCode: getValueFor(attributeName: "zipCode", updatedFieldValue: updatedFieldValue),
                                        name: getValueFor(attributeName: "name", updatedFieldValue: updatedFieldValue))

        sessionProvider.request(type: User.self, service: service) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let account):
                if let account = account {
                    self.account = account
                    self.delegate?.updatedAccount()
                }
            case .failure(let error):
                self.delegate?.failedToUpdateAccount(error: error)
            }
        }
    }

    private func getValueFor(attributeName: String, updatedFieldValue: String) -> String {
        if attributeName == self.fieldName {
            return updatedFieldValue
        } else {
            switch attributeName {
            case "name":
                return self.account.name ?? ""
            case "zipCode":
                return self.account.zipCode
            default:
               return ""
            }
        }
    }
}
