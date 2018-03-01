//
//  ParseLeagueSessionsOperation.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

class ParseLeagueSessionsOperation: Operation {
    var leagueSessions: [LeagueSession]?
    var html: String?
    
    override func main() {
        do {
            let parser = try Parser(html: html)
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
