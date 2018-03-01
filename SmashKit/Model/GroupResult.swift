//
//  GroupResult.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

enum MatrixValue {
    case value(Int), forfeit, none
    
    init(text: String) throws {
        if text == "_" { self = MatrixValue.none }
        if text == "F" { self = MatrixValue.forfeit }
        if let int = Int(text) { self = MatrixValue.value(int) }
        throw TableTennisError.unrecognizedMatrixValue
    }
    
    var intValue: Int {
        switch self {
        case .value(let val): return val
        case .forfeit, .none: return 0
        }
    }
    
    var textValue: String {
        switch self {
        case .value(let val): return "\(val)"
        case .forfeit: return "F"
        case .none: return "_"
        }
    }
}

struct GroupMatrix: Codable {
    enum MatrixType: String {
        case wins, points
    }
    private enum CodingKeys: CodingKey {
        case type, results
    }
    
    var type: MatrixType
    var results: [[MatrixValue]] = []
    
    init(type: MatrixType) {
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let typeString = try container.decode(String.self, forKey: .type)
        type = MatrixType(rawValue: typeString) ?? .wins
        
        let resultsStringMatrix = try container.decode([[String]].self, forKey: .results)
        results = try resultsStringMatrix.map { try $0.map { try MatrixValue(text: $0) } }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(results.map { $0.map { $0.textValue } }, forKey: .results)
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
    
    internal init(groupNumber: Int, players: [Player], winsMatrix: GroupMatrix, pointsMatrix: GroupMatrix, netRatingChanges: [String:Int], finalRatings: [String:Int]) throws {
        self.groupNumber = groupNumber
        self.winsMatrix = winsMatrix
        self.pointsMatrix = pointsMatrix
        self.netRatingChanges = netRatingChanges
        self.finalRatings = finalRatings
        self.players = players
        
        try extractMatches()
    }
    
    private mutating func extractMatches() throws {
        guard winsMatrix.results.count == pointsMatrix.results.count else { throw TableTennisError.mismatchedWinsAndPointsMatrices }
        
        matches = [Match]()
        
        for i in 0 ..< winsMatrix.results.count {
            for j in i + 1 ..< winsMatrix.results[i].count {
                let player1 = players[i]
                let player2 = players[j]
                let player1Wins = winsMatrix.results[i][j].intValue
                let ratingChange = pointsMatrix.results[i][j].intValue
                let player2Wins = winsMatrix.results[j][i].intValue
                
                let match = Match(player1: player1, player2: player2, player1Wins: player1Wins, player2Wins: player2Wins, ratingChange: abs(ratingChange))
                matches.append(match)
            }
        }
    }
}
