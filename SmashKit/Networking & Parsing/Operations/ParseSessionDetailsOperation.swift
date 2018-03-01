//
//  ParseSessionDetailsOperation.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

class ParseSessionDetailsOperation: Operation {
    var leagueSession: LeagueSession?
    var html: String?
    
    override func main() {
        do {
            let parser = try Parser(html: html)
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
