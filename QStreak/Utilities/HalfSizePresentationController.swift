//
//  HalfSizePresentationController.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/6/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class HalfSizePresentationController: UIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let parentView = containerView else {
            return CGRect.zero
        }

        return CGRect(x: 0, y: parentView.bounds.height/2, width: parentView.bounds.width, height: parentView.bounds.height/2)
    }
}
