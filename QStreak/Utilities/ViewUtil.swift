//
//  ViewUtil.swift
//  QStreak
//
//  Created by Daniel McCoy on 5/13/20.
//  Copyright © 2020 Rocket Insights. All rights reserved.
//

import Foundation
import UIKit

class ViewUtil {
    private static let layerNameTopBorder = "topBorder"
    private static let layerNameBottomBorder = "bottomBorder"
    private static let layerNameLeftBorder = "leftBorder"
    private static let layerNameRightBorder = "rightBorder"
    
    static func setBorders(view: UIView, top topWidth: CGFloat, bottom bottomWidth: CGFloat, left leftWidth: CGFloat, right rightWidth: CGFloat, color: UIColor, inset:Bool = true) {
        var topBorderLayer:CALayer?
        var bottomBorderLayer:CALayer?
        var leftBorderLayer:CALayer?
        var rightBorderLayer:CALayer?
        for borderLayer in (view.layer.sublayers)! {
            if borderLayer.name == layerNameTopBorder {
                topBorderLayer = borderLayer
            } else if borderLayer.name == layerNameRightBorder {
                rightBorderLayer = borderLayer
            } else if borderLayer.name == layerNameLeftBorder {
                leftBorderLayer = borderLayer
            } else if borderLayer.name == layerNameBottomBorder {
                bottomBorderLayer = borderLayer
            }
        }


        // top border
        if topBorderLayer == nil {
            topBorderLayer = CALayer()
            topBorderLayer!.name = layerNameTopBorder
            view.layer.addSublayer(topBorderLayer!)
        }
        if inset {
            topBorderLayer!.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: view.bounds.width, height: topWidth)
        } else {
            topBorderLayer!.frame = CGRect(x: view.bounds.minX - leftWidth, y: view.bounds.minY - topWidth, width: view.bounds.width + leftWidth + rightWidth, height: topWidth)
        }
        topBorderLayer!.backgroundColor = color.cgColor


        // bottom border
        if bottomBorderLayer == nil {
            bottomBorderLayer = CALayer()
            bottomBorderLayer!.name = layerNameBottomBorder
            view.layer.addSublayer(bottomBorderLayer!)
        }
        if bottomWidth >= 0 {
            if inset {
                bottomBorderLayer!.frame = CGRect(x: view.bounds.minX, y:view.bounds.size.height - bottomWidth, width:view.bounds.size.width, height: bottomWidth)
            } else {
                bottomBorderLayer!.frame = CGRect(x: view.bounds.minX - leftWidth, y:view.bounds.size.height, width:view.bounds.size.width + leftWidth + rightWidth, height: bottomWidth)
            }
            bottomBorderLayer!.backgroundColor = color.cgColor
        }

        // left border
        if leftBorderLayer == nil {
            leftBorderLayer = CALayer()
            leftBorderLayer!.name = layerNameLeftBorder
            view.layer.addSublayer(leftBorderLayer!)
        }
        if inset {
            leftBorderLayer!.frame = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: leftWidth, height: view.bounds.height)
        } else {
            leftBorderLayer!.frame = CGRect(x: view.bounds.minX - leftWidth, y: view.bounds.minY, width: leftWidth, height: view.bounds.height)
        }
        leftBorderLayer!.backgroundColor = color.cgColor


        // right border
        if rightBorderLayer == nil {
            rightBorderLayer = CALayer()
            rightBorderLayer!.name = layerNameRightBorder
            view.layer.addSublayer(rightBorderLayer!)
        }
        if inset {
            rightBorderLayer!.frame = CGRect(x: view.bounds.width - rightWidth, y: 0, width: rightWidth, height: view.bounds.height)
        } else {
            rightBorderLayer!.frame = CGRect(x: view.bounds.width, y: 0, width: rightWidth, height: view.bounds.height)
        }
        rightBorderLayer!.backgroundColor = color.cgColor
    }
    
}
