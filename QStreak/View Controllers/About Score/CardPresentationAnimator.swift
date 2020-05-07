//
//  CardPresentationAnimator.swift
//  QStreak
//
//  Created by Mithun Reddy on 5/7/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import UIKit

class CardPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to) else { return }

        let containerView = transitionContext.containerView

        let animationDuration = transitionDuration(using: transitionContext)

        toViewController.view.transform = CGAffineTransform(translationX: 0, y: containerView.frame.height)
        toViewController.view.layer.shadowColor = UIColor.black.cgColor
        toViewController.view.layer.shadowOffset = CGSize(width: 0, height: 2)
        toViewController.view.layer.shadowOpacity = 0.3
        toViewController.view.layer.cornerRadius = 15
        toViewController.view.clipsToBounds = true

        containerView.addSubview(toViewController.view)

        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
            toViewController.view.transform = .identity
        }, completion: { finished in
            transitionContext.completeTransition(finished)
        })
    }
}
