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
    var leagueSession: LeagueSession?
    var html: String?
    var managedObjectContext: NSManagedObjectContext
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }
    
    override func main() {
        do {
            let parser = try Parser(html: html, managedObjectContext: managedObjectContext)
            try parser.parseGameTables(leagueSession: &leagueSession)
            
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
