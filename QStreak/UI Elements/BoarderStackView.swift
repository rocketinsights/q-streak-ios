//
//  BoarderStackView.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/13/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation
import UIKit

class BorderView: UIView {

    @IBInspectable var inset:Bool = true {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var bottomBorder: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var rightBorder: CGFloat = 1 {
        didSet {

            setNeedsLayout()
        }
    }

    @IBInspectable var leftBorder: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var topBorder: CGFloat = 1 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.lightGray {
        didSet {
            setNeedsLayout()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        ViewUtil.setBorders(view: self, top: topBorder, bottom: bottomBorder, left: leftBorder, right: rightBorder, color: borderColor, inset: inset)
    }
}
