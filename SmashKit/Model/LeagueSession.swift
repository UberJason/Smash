//
//  Session.swift
//  SmashKit
//
//  Created by Jason Ji on 2/26/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public class LeagueSession {
    public var numberOfGroups: Int { return groupResults?.count ?? 0 }
    public var numberOfPlayers: Int { return groupResults?.map { $0.players }.flatMap { $0 }.count ?? 0 }
    
    public var date: Date?
    public var groupResults: [GroupResult]?
    
    public init() {}
    
    public init(date: Date) {
        self.date = date
    }
    
    public init(date: Date, groupResults: [GroupResult]) {
        self.date = date
        self.groupResults = groupResults
    }
    
    public func group(for player: Player) -> GroupResult? {
        return groupResults?.filter { $0.players.contains(player) }.first
    }
}
