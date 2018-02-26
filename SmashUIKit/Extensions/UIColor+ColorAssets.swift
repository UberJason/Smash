//
//  UIColor+ColorAssets.swift
//  SmashUIKit
//
//  Created by Jason Ji on 2/25/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public extension UIColor {
    public static var victoryGreen: UIColor {
        return UIColor(named: "victoryGreen", in: Bundle(for: self), compatibleWith: nil)!
    }
    public static var defeatRed: UIColor {
        return UIColor(named: "defeatRed", in: Bundle(for: self), compatibleWith: nil)!
    }
}

