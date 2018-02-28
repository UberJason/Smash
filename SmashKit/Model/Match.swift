//
//  Match.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public struct Match {
    public let player1: Player
    public let player2: Player
    public let player1Wins: Int
    public let player2Wins: Int
    
    public let isForfeit: Bool
    public let ratingChange: Int
    
    public init(player1: Player, player2: Player, player1Wins: Int, player2Wins: Int, ratingChange: Int) {
        self.player1 = player1
        self.player2 = player2
        self.player1Wins = player1Wins
        self.player2Wins = player2Wins
        self.ratingChange = ratingChange
        self.isForfeit = (player1Wins == 0 && player2Wins == 0 && ratingChange == 0)
    }
}

public extension Match {
    public var winner: Player {
        return player1Wins > player2Wins ? player1 : player2
    }
    
    public var loser: Player {
        return player1Wins > player2Wins ? player2 : player1
    }
    
    public var score: String {
        return player1Wins > player2Wins ? "\(player1Wins)-\(player2Wins)" : "\(player2Wins)-\(player1Wins)"
    }
    
    public var p1RatingChange: Int {
        return winner == player1 ? ratingChange : -1*ratingChange
    }
    
    public var p2RatingChange: Int {
        return winner == player2 ? ratingChange : -1*ratingChange
    }
    
    public func contains(player: Player) -> Bool {
        return player1 == player || player2 == player
    }
    
    public func ratingChange(for player: Player) -> Int? {
        guard contains(player: player) else { return nil }
        return player == player1 ? p1RatingChange : p2RatingChange
    }
}

extension Match: CustomStringConvertible {
    public var description: String {
        return "\(winner.name) def. \(loser.name) \(score); \(player1.name) \(p1RatingChange), \(player2.name) \(p2RatingChange)\n"
    }
}
