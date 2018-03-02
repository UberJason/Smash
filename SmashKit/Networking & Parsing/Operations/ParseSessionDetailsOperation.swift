//
//  ParseSessionDetailsOperation.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

class ParseSessionDetailsOperation: Operation {
    var html: String?
    var managedObjectContext: NSManagedObjectContext
    var leagueSessionObjectID: NSManagedObjectID
    
    init(managedObjectContext: NSManagedObjectContext, leagueSessionObjectID: NSManagedObjectID) {
        self.managedObjectContext = managedObjectContext
        self.leagueSessionObjectID = leagueSessionObjectID
    }
    
    override func main() {
        do {
            let parser = try Parser(html: html, managedObjectContext: managedObjectContext)
            let leagueSession = managedObjectContext.object(with: leagueSessionObjectID) as! LeagueSession
            let groupResults = try parser.parseGameTables()
            leagueSession.groupResults?.forEach { managedObjectContext.delete($0) }
            leagueSession.groupResults = groupResults
            
        } catch {
            print("Unknown error parsing - maybe rewrite this code and catch individual TableTennisErrors...")
        }
    }
}

extension ParseSessionDetailsOperation: DownloadSessionDetailsOperationDelegate {
    func leagueSessionDetailsDownloaded(_ html: String) {
        self.html = html
    }
}
