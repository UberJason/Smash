//
//  Session.swift
//  SmashKit
//
//  Created by Jason Ji on 2/26/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public struct LeagueSession {
    public var numberOfGroups: Int { return groupResults.count }
    public var numberOfPlayers: Int { return groupResults.map { $0.players }.flatMap { $0 }.count }
    
    public var groupResults: [GroupResult]
    
    init(groupResults: [GroupResult]) {
        self.groupResults = groupResults
    }
    
    public func group(for player: Player) -> GroupResult? {
        return groupResults.filter { $0.players.contains(player) }.first
    }
}
