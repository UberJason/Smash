//
//  Player.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public struct Player: Equatable, Hashable {
    public var hashValue: Int { return name.hashValue }
    
    public let name: String
    
    public init(name: String) {
        self.name = name
    }
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
}
