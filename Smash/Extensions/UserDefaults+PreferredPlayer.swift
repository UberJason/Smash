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
    var preferredPlayer: Player? {
        get {
            if let name = string(forKey: UserDefaults.preferredPlayerKey) {
                return Player(name: name)
            }
            return nil
        }
        set {
            set(newValue?.name, forKey: UserDefaults.preferredPlayerKey)
            synchronize()
        }
    }
}
