//
//  ScorekeepingMatch.swift
//  SmashKit
//
//  Created by Jason Ji on 11/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData
import SmashKitWatch

public class ScorekeepingMatch: Equatable {
    let id: UUID = UUID()
    
    public var player1: Player
    public var player2: Player
    public var games: [Game]
    
    public init(player1: Player, player2: Player, games: [Game]? = nil) {
        self.player1 = player1
        self.player2 = player2
        self.games = games ?? []
    }
    
    func summaryDescription(for primaryPlayer: Player) -> String {
        let wins = self.wins(for: primaryPlayer)
        let losses = self.losses(for: primaryPlayer)
        
        let net = wins - losses
        switch net {
        case _ where net > 0:
            return "W, \(wins)-\(losses)"
        case _ where net == 0:
            return "T, \(wins)-\(losses)"
        case _ where net < 0:
            return "L, \(wins)-\(losses)"
        default: fatalError("Impossible arithmetic?")
        }
    }
    
    public static func ==(lhs: ScorekeepingMatch, rhs: ScorekeepingMatch) -> Bool {
        return lhs.id == rhs.id
    }
    
    func wins(for player: Player) -> Int {
        return games.filter { $0.winner == player }.count
    }
    
    func losses(for player: Player) -> Int {
        return games.filter { $0.winner != player }.count
    }
    
    var isComplete: Bool {
        let wins = self.wins(for: player1)
        let losses = self.losses(for: player1)
        
        return wins >= 3 || losses >= 3
    }
}
