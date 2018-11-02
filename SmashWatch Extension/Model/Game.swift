//
//  Game.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import SmashKitWatch

public class Game: Equatable {
    public let id: UUID = UUID()
    public var player1: Player
    public var player2: Player
    
    public var player1Score: Int
    public var player2Score: Int
    
    public init(player1: Player, player2: Player, player1Score: Int, player2Score: Int) {
        self.player1 = player1
        self.player2 = player2
        self.player1Score = player1Score
        self.player2Score = player2Score
    }
    
    public func outcomeDescription(for primaryPlayer: Player) -> String? {
        guard primaryPlayer == player1 || primaryPlayer == player2 else { return nil }
        if primaryPlayer == player1 {
            return "\(winner == player1 ? "W" : "L"), \(player1Score)-\(player2Score)"
        }
        else {
            return "\(winner == player2 ? "W" : "L"), \(player2Score)-\(player1Score)"
        }
    }
    
    public var winner: Player {
        return player1Score > player2Score ? player1 : player2
    }
    
    public static func ==(lhs: Game, rhs: Game) -> Bool {
        return lhs.id == rhs.id
    }
    
}
