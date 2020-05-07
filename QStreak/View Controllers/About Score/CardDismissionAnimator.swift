//
//  CardDismissionAnimator.swift
//  QStreak
//
//  Created by Mithun Reddy on 5/7/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class CardDismissionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: .from) else { return }

        let containerView = transitionContext.containerView
        let animationDuration = transitionDuration(using: transitionContext)

        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            fromViewController.view.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}
