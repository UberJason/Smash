//
//  ParseLeagueSessionsOperation.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

class ParseLeagueSessionsOperation: Operation {
    var leagueSessions: [LeagueSession]?
    var html: String?
    var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    override func main() {
        do {
            let parser = try Parser(html: html, managedObjectContext: managedObjectContext)
            leagueSessions = try parser.parseLeagueReports()
            
        } catch {
            print("Unknown error parsing - maybe rewrite this code and catch individual TableTennisErrors...")
        }
    }
}

extension ParseLeagueSessionsOperation: DownloadLeagueSessionsOperationDelegate {
    func leagueSessionsDownloaded(_ html: String) {
        self.html = html
    }
}
