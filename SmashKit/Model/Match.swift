//
//  Match.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

struct Match {
    let player1: Player
    let player2: Player
    let player1Wins: Int
    let player2Wins: Int
    
    let ratingChange: Int
    
    var winner: Player {
        return player1Wins > player2Wins ? player1 : player2
    }
    var loser: Player {
        return player1Wins > player2Wins ? player2 : player1
    }
    
    var score: String {
        return player1Wins > player2Wins ? "\(player1Wins)-\(player2Wins)" : "\(player2Wins)-\(player1Wins)"
    }
    
    var p1RatingChange: Int {
        return winner == player1 ? ratingChange : -1*ratingChange
    }
    var p2RatingChange: Int {
        return winner == player2 ? ratingChange : -1*ratingChange
    }
}

extension Match: CustomStringConvertible {
    var description: String {
        return "\(winner.name) def. \(loser.name) \(score); \(player1.name) \(p1RatingChange), \(player2.name) \(p2RatingChange)\n"
    }
}
