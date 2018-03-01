//
//  NetworkController.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

public class NetworkController {
    private var operationQueue = OperationQueue()
    public static let sharedInstance = NetworkController()
    
    private init() {}
    
    public func fetchLeagueSessions(_ completionHandler: @escaping ([LeagueSession]) -> Void) {
        let downloadLeagueSessionsOperation = DownloadLeagueSessionsOperation()
        let parseLeagueSessionsOperation = ParseLeagueSessionsOperation()
        
        downloadLeagueSessionsOperation.delegate = parseLeagueSessionsOperation
        parseLeagueSessionsOperation.addDependency(downloadLeagueSessionsOperation)
        
        let finalOperation = BlockOperation {
            completionHandler(parseLeagueSessionsOperation.leagueSessions ?? [])
        }
        finalOperation.addDependency(parseLeagueSessionsOperation)
        
        operationQueue.isSuspended = true
        operationQueue.addOperations([downloadLeagueSessionsOperation, parseLeagueSessionsOperation, finalOperation], waitUntilFinished: false)
        operationQueue.isSuspended = false
    }
    
    public func fetchLeagueSessionDetails(_ sessionURL: String, completionHandler: @escaping (LeagueSession?) -> Void) {
        guard let url = URL(string: sessionURL) else {
            print("Invalid session URL.")
            completionHandler(nil)
            return
        }
        
        let downloadSessionDetailsOperation = DownloadSessionDetailsOperation(sessionDownloadURL: url)
        let parseSessionDetailsOperation = ParseSessionDetailsOperation()
        
        downloadSessionDetailsOperation.delegate = parseSessionDetailsOperation
        parseSessionDetailsOperation.addDependency(downloadSessionDetailsOperation)
        
        let finalOperation = BlockOperation {
            completionHandler(parseSessionDetailsOperation.leagueSession)
        }
        finalOperation.addDependency(parseSessionDetailsOperation)
        
        operationQueue.isSuspended = true
        operationQueue.addOperations([downloadSessionDetailsOperation, parseSessionDetailsOperation, finalOperation], waitUntilFinished: false)
        operationQueue.isSuspended = false
    }
}
