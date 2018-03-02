//
//  UserDefaults+PreferredPlayer.swift
//  Smash
//
//  Created by Jason Ji on 3/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import SmashKit

extension UserDefaults {
    static let preferredPlayerKey = "preferredPlayer"
    var preferredPlayer: String? {
        get {
            if let name = string(forKey: UserDefaults.preferredPlayerKey) {
                return name
            }
            return nil
        }
        set {
            set(newValue, forKey: UserDefaults.preferredPlayerKey)
            synchronize()
        }
    }
}
