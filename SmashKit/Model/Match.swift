//
//  Match.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

public class Match: NSManagedObject {
    public var player1: Player {
        get {
            return player1CD!
        }
        set {
            player1CD = newValue
        }
    }
    public var player2: Player {
        get {
            return player2CD!
        }
        set {
            player2CD = newValue
        }
    }
    public var player1Wins: Int {
        get {
            return Int(player1WinsCD)
        }
        set {
            player1WinsCD = Int32(newValue)
        }
    }
    public var player2Wins: Int {
        get {
            return Int(player2WinsCD)
        }
        set {
            player2WinsCD = Int32(newValue)
        }
    }
    
    public var isForfeit: Bool {
        get {
            return isForfeitCD
        }
        set {
            isForfeitCD = newValue
        }
    }
    public var ratingChange: Int {
        get {
            return Int(ratingChangeCD)
        }
        set {
            ratingChangeCD = Int32(newValue)
        }
    }
    
    public convenience init(player1: Player, player2: Player, player1Wins: Int, player2Wins: Int, ratingChange: Int, managedObjectContext: NSManagedObjectContext) {
        self.init(context: managedObjectContext)
        
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

extension Match {
    public override var description: String {
        return "\(winner.name) def. \(loser.name) \(score); \(player1.name) \(p1RatingChange), \(player2.name) \(p2RatingChange)\n"
    }
}
