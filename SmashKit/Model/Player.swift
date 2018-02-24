//
//  Player.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

struct Player: Equatable {
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
    
    let name: String
}
