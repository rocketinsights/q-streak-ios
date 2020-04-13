//
//  RecordListViewModel.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/8/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation

protocol RecordListViewModelDelegate: AnyObject {
    func showRecordDetailViewController(recordDetailViewModel: RecordDetailViewModel)
}

class RecordListViewModel {
    
    // MARK: - Properties

    weak var delegate: RecordListViewModelDelegate?

    // TODO: - Dummy Values
    let records = [Record(creationDate: Date(), contactCount: 2, activities: [Activity(name: "Grocery Store", activityID: 1)]),
                   Record(creationDate: Date(), contactCount: 1, activities: [Activity(name: "Grocery Store", activityID: 1)]),
                   Record(creationDate: Date(), contactCount: 6, activities: [Activity(name: "Grocery Store", activityID: 1)]),
                   Record(creationDate: Date(), contactCount: 23, activities: [Activity(name: "Grocery Store", activityID: 1)]),
                   Record(creationDate: Date(), contactCount: 2423, activities: [Activity(name: "Grocery Store", activityID: 1)])]
    

    func userTappedRecordCell(_ indexPath: IndexPath) {
        let selectedRecord = records[indexPath.row]
        let recordDetailViewModel = RecordDetailViewModel(record: selectedRecord)
        
        delegate?.showRecordDetailViewController(recordDetailViewModel: recordDetailViewModel)
    }
 }
