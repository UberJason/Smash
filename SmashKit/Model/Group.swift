//
//  Group.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public struct GroupMatrix {
    enum MatrixType {
        case wins, points
    }
    var players: [Player] = []
    var results: [[Int]] = []
    var type: MatrixType
    
    init(type: MatrixType) {
        self.type = type
    }
}

public struct GroupResult {
    public let winsMatrix: GroupMatrix
    public let pointsMatrix: GroupMatrix
    
    public var matches = [Match]()
    
    public init(winsMatrix: GroupMatrix, pointsMatrix: GroupMatrix) throws {
        self.winsMatrix = winsMatrix
        self.pointsMatrix = pointsMatrix
        try extractMatches()
    }
    
    private mutating func extractMatches() throws {
        guard winsMatrix.results.count == pointsMatrix.results.count,
            winsMatrix.players == pointsMatrix.players else { throw TableTennisError.mismatchedWinsAndPointsMatrices }
        
        matches = [Match]()
        let players = winsMatrix.players
        
        for i in 0 ..< winsMatrix.results.count {
            for j in i + 1 ..< winsMatrix.results[i].count {
                let player1 = players[i]
                let player2 = players[j]
                let player1Wins = winsMatrix.results[i][j]
                let player2Wins = winsMatrix.results[j][i]
                let ratingChange =  pointsMatrix.results[i][j]
                
                let match = Match(player1: player1, player2: player2, player1Wins: player1Wins, player2Wins: player2Wins, ratingChange: ratingChange)
                matches.append(match)
            }
        }
    }
}
