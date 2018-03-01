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
    public var reportURL: String?
    public var groupResults: [GroupResult]?
    
    public init(date: Date? = nil, reportURL: String? = nil) {
        self.date = date
        self.reportURL = reportURL
    }
    
    public init(date: Date?, groupResults: [GroupResult]) {
        self.date = date
        self.groupResults = groupResults
    }
    
    public func group(for player: Player) -> GroupResult? {
        return groupResults?.filter { $0.players.contains(player) }.first
    }
}

extension LeagueSession: Hashable {
    public var hashValue: Int {
        return date?.hashValue ?? 0
    }
    
    public static func ==(lhs: LeagueSession, rhs: LeagueSession) -> Bool {
        return lhs.date == rhs.date && lhs.reportURL == rhs.reportURL
    }
}

