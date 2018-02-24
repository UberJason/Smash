//
//  Parser.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import SwiftSoup

class Parser {
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
