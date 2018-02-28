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
    var document: Document
    
    public init(html: String) throws {
        document = try SwiftSoup.parse(html)
    }
    
    public func parseLeagueReports() throws -> [LeagueSession] {
        return []
    }
    
    private static let sessionDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd-MMM-yy"
        return f
    }()
    
    public func parseGameTables(leagueSession: inout LeagueSession?) throws {
        // "Session Date: 20-Feb-18", relevant data starts at index 12
        guard let sessionDateText = try document.getElementsByClass(Strings.date).array().first?.text(),
            let sessionDate = Parser.sessionDateFormatter.date(from: String(sessionDateText.dropFirst(13)))
            else { throw TableTennisError.missingDate }
        
        var tables = try document.select(Strings.table).array()
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
        leagueSession = leagueSession ?? LeagueSession()
        leagueSession?.date = sessionDate
        leagueSession?.groupResults = groupResults
    }
    
    func tableTennisElementToMatrixValue(_ element: Element) throws -> MatrixValue {
        let text = try element.text()
        if text == "_" { return MatrixValue.none }
        if text == "F" { return MatrixValue.forfeit }
        if let int = Int(text) { return MatrixValue.value(int) }
        throw TableTennisError.unrecognizedMatrixValue
    }
}
