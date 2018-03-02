//
//  NetworkController.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation
import CoreData

public class NetworkController {
    private var operationQueue = OperationQueue()
    public static let sharedInstance = NetworkController()
    
    private init() {}
    
    public func fetchLeagueSessions(_ completionHandler: @escaping ([LeagueSession]) -> Void) {
        let context = SmashStackManager.shared.createTemporaryContext()
        
        let downloadLeagueSessionsOperation = DownloadLeagueSessionsOperation()
        let parseLeagueSessionsOperation = ParseLeagueSessionsOperation(managedObjectContext: context)
        
        downloadLeagueSessionsOperation.delegate = parseLeagueSessionsOperation
        parseLeagueSessionsOperation.addDependency(downloadLeagueSessionsOperation)
        
        let finalOperation = BlockOperation {
            SmashStackManager.shared.saveWithTemporaryContext(context)
            completionHandler(parseLeagueSessionsOperation.leagueSessions ?? [])
        }
        finalOperation.addDependency(parseLeagueSessionsOperation)
        
        operationQueue.isSuspended = true
        operationQueue.addOperations([downloadLeagueSessionsOperation, parseLeagueSessionsOperation, finalOperation], waitUntilFinished: false)
        operationQueue.isSuspended = false
    }
    
    public func fetchLeagueSessionDetails(_ leagueSession: LeagueSession, completionHandler: @escaping (LeagueSession?) -> Void) {
        guard let sessionURL = leagueSession.reportURL, let url = URL(string: sessionURL) else {
            print("Invalid session URL.")
            completionHandler(nil)
            return
        }
        
        let context = SmashStackManager.shared.createTemporaryContext()
        
        let downloadSessionDetailsOperation = DownloadSessionDetailsOperation(sessionDownloadURL: url)
        let parseSessionDetailsOperation = ParseSessionDetailsOperation(managedObjectContext: context, leagueSessionObjectID: leagueSession.objectID)
        
        downloadSessionDetailsOperation.delegate = parseSessionDetailsOperation
        parseSessionDetailsOperation.addDependency(downloadSessionDetailsOperation)
        
        let finalOperation = BlockOperation {
            SmashStackManager.shared.saveWithTemporaryContext(context)
            DispatchQueue.main.async {
                let leagueSession = SmashStackManager.shared.managedObjectContext.object(with: parseSessionDetailsOperation.leagueSessionObjectID) as! LeagueSession
                completionHandler(leagueSession)
            }
        }
        finalOperation.addDependency(parseSessionDetailsOperation)
        
        operationQueue.isSuspended = true
        operationQueue.addOperations([downloadSessionDetailsOperation, parseSessionDetailsOperation, finalOperation], waitUntilFinished: false)
        operationQueue.isSuspended = false
    }
}
