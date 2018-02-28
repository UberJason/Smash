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
    
    public func parseGameTables(_ doc: Document) throws -> LeagueSession {
        var tables = try doc.select(Strings.table).array()
        tables.remove(at: 0)
        tables.remove(at: 0)
        
        var groupResults = [GroupResult]()
        
        for (index, table) in tables.enumerated() {
            var winsGroupMatrix = GroupMatrix(type: .wins)
            var pointsGroupMatrix = GroupMatrix(type: .points)
            var netRatingChanges = [String:Int]()
            var finalRatings = [String:Int]()
            
            let rows = try table.select(Strings.tr).array()
            for row in rows {
                guard let name = try row.getElementsByClass(Strings.datacolumn1).first()?.text() else { throw TableTennisError.missingName }
                
                winsGroupMatrix.players.append(Player(name: name))
                pointsGroupMatrix.players.append(Player(name: name))
                
                let gamesWon = try row.getElementsByClass(Strings.gamesemcolumn).array().map(tableTennisElementToMatrixValue)
                winsGroupMatrix.results.append(gamesWon)
                
                let pointsWon = try row.select(Strings.td).array().filter { try $0.className() == "" }.map(tableTennisElementToMatrixValue)
                pointsGroupMatrix.results.append(pointsWon)
                
                guard let netRatingChangeText = try row.getElementsByClass(Strings.nracolumn).first()?.text(),
                    let netRatingChange = Int(netRatingChangeText) else { throw TableTennisError.missingNetRatingChange }
                netRatingChanges[name] = netRatingChange
                
                guard let finalRatingText = try row.getElementsByClass(Strings.frcolumn).first()?.text(),
                    let finalRating = Int(finalRatingText) else { throw TableTennisError.missingFinalRating }
                finalRatings[name] = finalRating
            }
            
            groupResults.append(try GroupResult(groupNumber: index + 1, winsMatrix: winsGroupMatrix, pointsMatrix: pointsGroupMatrix, netRatingChanges: netRatingChanges, finalRatings: finalRatings))
        }
        
        return LeagueSession(groupResults: groupResults)
    }
    
    func tableTennisElementToMatrixValue(_ element: Element) throws -> MatrixValue {
        let text = try element.text()
        if text == "_" { return MatrixValue.none }
        if text == "F" { return MatrixValue.forfeit }
        if let int = Int(text) { return MatrixValue.value(int) }
        throw TableTennisError.unrecognizedMatrixValue
    }
}

enum MatrixValue {
    case value(Int), forfeit, none
    var intValue: Int {
        switch self {
        case .value(let val): return val
        case .forfeit, .none: return 0
        }
    }
}

struct GroupMatrix {
    enum MatrixType {
        case wins, points
    }
    var players: [Player] = []
    var results: [[MatrixValue]] = []
    var type: MatrixType
    
    init(type: MatrixType) {
        self.type = type
    }
}

public struct GroupResult {
    private let winsMatrix: GroupMatrix
    private let pointsMatrix: GroupMatrix
    
    private var finalRatings: [String:Int]
    private var netRatingChanges: [String:Int]
    
    public var matches = [Match]()
    public var players: [Player]
    public var groupNumber: Int
    
    public func finalRating(for player: Player) -> Int? {
        return finalRatings[player.name]
    }
    
    public func initialRating(for player: Player) -> Int? {
        guard let net = netRatingChange(for: player), let final = finalRating(for: player) else { return nil }
        return final - net
    }
    
    public func netRatingChange(for player: Player) -> Int? {
        return netRatingChanges[player.name]
    }
    
    internal init(groupNumber: Int, winsMatrix: GroupMatrix, pointsMatrix: GroupMatrix, netRatingChanges: [String:Int], finalRatings: [String:Int]) throws {
        self.groupNumber = groupNumber
        self.winsMatrix = winsMatrix
        self.pointsMatrix = pointsMatrix
        self.netRatingChanges = netRatingChanges
        self.finalRatings = finalRatings
        self.players = winsMatrix.players
        
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
                let player1Wins = winsMatrix.results[i][j].intValue
                let ratingChange = pointsMatrix.results[i][j].intValue
                let player2Wins = winsMatrix.results[j][i].intValue
                
                let match = Match(player1: player1, player2: player2, player1Wins: player1Wins, player2Wins: player2Wins, ratingChange: ratingChange)
                matches.append(match)
            }
        }
    }
}
