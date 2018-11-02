//
//  WKPickerItem+InitWithTitle.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit

public extension WKPickerItem {
    public convenience init(title: String) {
        self.init()
        self.title = title
    }
}
