//
//  Parser.swift
//  SmashKit
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData
import SwiftSoup

public class Parser {
    var document: Document
    var managedObjectContext: NSManagedObjectContext
    
    struct LeagueSessionLink: Hashable {
        static func ==(lhs: Parser.LeagueSessionLink, rhs: Parser.LeagueSessionLink) -> Bool {
            return lhs.url == rhs.url && lhs.title == rhs.title
        }
        
        var hashValue: Int {
            return (url+title).hashValue
        }
        
        let url: String
        let title: String
        
        var sessionDate: Date? {
            // "Session Group Report for February 23, 2018", relevant data starts at index 26
            let dateString = String(title.dropFirst(25))
            return Parser.sessionLongDateFormatter.date(from: dateString)
        }
        
        init(url: String, title: String) {
            self.url = url
            self.title = title
        }
    }
    
    private static let sessionShortDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd-MMM-yy"
        return f
    }()
    private static let sessionLongDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        return f
    }()
    
    public init(html: String?, managedObjectContext: NSManagedObjectContext) throws {
        guard let html = html else { throw TableTennisError.invalidHtml }
        self.managedObjectContext = managedObjectContext
        
        document = try SwiftSoup.parse(html)
    }
    
    public func parseLeagueReports() throws -> [LeagueSession] {
        guard var links = try document.getElementById(Strings.MainCPH_BulletedList1)?.getElementsByTag(Strings.a).array().map({ LeagueSessionLink(url: try $0.attr(Strings.href), title: try $0.text()) }) else { throw TableTennisError.missingLeagueSessionLinks }
        
        // There are sometimes duplicate reports. Remove them.
        links = Array(Set<LeagueSessionLink>(links))
        
        let leagueSessions = links.map {
            LeagueSession(date: $0.sessionDate, reportURL: $0.url, managedObjectContext: managedObjectContext)
            }.filter {
                $0.date != nil
            }.sorted {
                $0.date! > $1.date!
            }
        
        return leagueSessions
    }
    
    public func parseGameTables(leagueSession: inout LeagueSession?) throws {
        // "Session Date: 20-Feb-18", relevant data starts at index 14
        guard let sessionDateText = try document.getElementsByClass(Strings.date).array().first?.text(),
            let sessionDate = Parser.sessionShortDateFormatter.date(from: String(sessionDateText.dropFirst(13)))
            else { throw TableTennisError.missingDate }
        
        var tables = try document.select(Strings.table).array()
        tables.remove(at: 0)
        tables.remove(at: 0)
        
        var groupResults = [GroupResult]()
        
        for (index, table) in tables.enumerated() {
            var players = [Player]()
            var winsGroupMatrix = GroupMatrix(type: .wins)
            var pointsGroupMatrix = GroupMatrix(type: .points)
            var netRatingChanges = [String:Int]()
            var finalRatings = [String:Int]()
            
            let rows = try table.select(Strings.tr).array()
            for row in rows {
                guard let name = try row.getElementsByClass(Strings.datacolumn1).first()?.text() else { throw TableTennisError.missingName }
                
                players.append(Player(name: name, managedObjectContext: managedObjectContext))
                
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
            
            groupResults.append(try GroupResult(groupNumber: index + 1, players: players, winsMatrix: winsGroupMatrix, pointsMatrix: pointsGroupMatrix, netRatingChanges: netRatingChanges, finalRatings: finalRatings, managedObjectContext: managedObjectContext))
        }
        leagueSession = leagueSession ?? LeagueSession()
        leagueSession?.date = sessionDate
        leagueSession?.groupResults = groupResults
    }
    
    func tableTennisElementToMatrixValue(_ element: Element) throws -> MatrixValue {
        let text = try element.text()
        let matrixValue = try MatrixValue(text: text)
        return matrixValue
    }
}
