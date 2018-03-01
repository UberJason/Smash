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
    
    public func fetchLeagueSessions(_ completionHandler: @escaping (([LeagueSession]) -> Void) ) {
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
}

protocol DownloadLeagueSessionsOperationDelegate: class {
    func leagueSessionsDownloaded(_ html: String)
}

class DownloadLeagueSessionsOperation: Operation {
    weak var delegate: DownloadLeagueSessionsOperationDelegate?
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: Constants.reportArchiveURL) { (data, response, error) in
            if let data = data {
                let html = String(data: data, encoding: .utf8)!
                self.delegate?.leagueSessionsDownloaded(html)
                semaphore.signal()
            }
            else {
                print(error?.localizedDescription ?? "Unknown error")
                semaphore.signal()
            }
        }
        task.resume()
        let _ = semaphore.wait(timeout: .distantFuture)
        print("Finished downloads")
    }
}

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
