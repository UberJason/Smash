//
//  Parser.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import SwiftSoup

public class Parser {
    public init() {}
    
    func parseGameTables(_ doc: Document) throws -> [GroupResult] {
        var tables = try doc.select(Strings.table).array()
        tables.remove(at: 0)
        tables.remove(at: 0)
        
        var groupResults = [GroupResult]()
        
        for table in tables {
            var winsGroupMatrix = GroupMatrix(type: .wins)
            var pointsGroupMatrix = GroupMatrix(type: .points)
            
            let rows = try table.select(Strings.tr).array()
            for row in rows {
                guard let name = try row.getElementsByClass(Strings.datacolumn1).first()?.text() else { throw TableTennisError.missingName }
                
                winsGroupMatrix.players.append(Player(name: name))
                pointsGroupMatrix.players.append(Player(name: name))
                
                let gamesWon = try row.getElementsByClass(Strings.gamesemcolumn).array().map(tableTennisElementToInt)
                winsGroupMatrix.results.append(gamesWon)
                
                let pointsWon = try row.select(Strings.td).array().filter { try $0.className() == "" }.map(tableTennisElementToInt)
                pointsGroupMatrix.results.append(pointsWon)
            }
            
            groupResults.append(try GroupResult(winsMatrix: winsGroupMatrix, pointsMatrix: pointsGroupMatrix))
        }
        
        return groupResults
    }
    
    func tableTennisElementToInt(_ element: Element) throws -> Int {
        let text = try element.text()
        if let int = Int(text) {
            return int
        }
        return -99
    }
}

struct GroupMatrix {
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
    private let winsMatrix: GroupMatrix
    private let pointsMatrix: GroupMatrix
    
    private var ratings: [Player:Int] = [:]
    
    public var matches = [Match]()
    public var players = [Player]()
    
    public func rating(for player: Player) -> Int? {
        return ratings[player]
    }
    
    internal init(winsMatrix: GroupMatrix, pointsMatrix: GroupMatrix) throws {
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
