//
//  Player.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public struct Player: Equatable {
    public let name: String
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
}
