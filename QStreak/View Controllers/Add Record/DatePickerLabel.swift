//
//  DatePickerLabel.swift
//  QStreak
//
//  Created by Mithun Reddy on 5/7/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

protocol DatePickerLabelDelegate: AnyObject {
    func datePickerDismissed()
}

class DatePickerLabel: UILabel {

    // MARK: - Properties

    var selectedDate: Date

    weak var delegate: DatePickerLabelDelegate?

    override var inputView: UIView? {
        let datePicker = UIDatePicker()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.date = selectedDate
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        return datePicker
    }

    override var inputAccessoryView: UIView? {
        let doneToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        return doneToolbar
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }

    override var canResignFirstResponder: Bool {
        return true
    }

    // MARK: - Initializers

    init(date: Date) {
        selectedDate = date
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        selectedDate = Date()
        super.init(coder: coder)
    }

    // MARK: - Methods

    @objc private func doneButtonAction() {
        delegate?.datePickerDismissed()
        resignFirstResponder()
    }

    @objc private func datePickerValueChanged(_ datePicker: UIDatePicker) {
        selectedDate = datePicker.date
    }
}
