//
//  UIView+AddSubviewFullFrame.swift
//  SmashUIKit
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public extension UIView {
    public func addSubviewFullFrame(_ subview: UIView, with insets: UIEdgeInsets = .zero, at index: Int? = nil, layoutImmediately: Bool = true) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        if let index = index {
            insertSubview(subview, at: index)
        }
        else {
            addSubview(subview)
        }
        
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -1*insets.right).isActive = true
        subview.topAnchor.constraint(equalTo: topAnchor, constant: insets.top).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1*insets.bottom).isActive = true
        
        if layoutImmediately {
            layoutIfNeeded()
        }
    }
}
