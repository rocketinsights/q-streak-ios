//
//  QTextField.swift
//  QStreak
//
//  Created by Mithun Reddy on 4/22/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

@IBDesignable class QTextField: UITextField {

    // MARK: - IBInspectables

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
            setBorderStyle()
        }
    }

    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }

    @IBInspectable var noTextBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor()
        }
    }

    @IBInspectable var hasTextBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor()
        }
    }

    @IBInspectable var leadingTrailingPadding: CGFloat = 0

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    // MARK: - Methods

    private func commonInit() {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        setBorderStyle()
        setBackgroundColor()
        enablesReturnKeyAutomatically = true
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: leadingTrailingPadding, bottom: 0, right: leadingTrailingPadding))
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.inset(by: UIEdgeInsets(top: 0, left: leadingTrailingPadding, bottom: 0, right: leadingTrailingPadding))
    }

    @objc private func editingChanged() {
        setBackgroundColor()
    }

    private func setBackgroundColor() {
        backgroundColor = hasText ? hasTextBackgroundColor : noTextBackgroundColor
    }

    private func setBorderStyle() {
        borderStyle = borderWidth > 0 ? borderStyle : .none
    }
}
