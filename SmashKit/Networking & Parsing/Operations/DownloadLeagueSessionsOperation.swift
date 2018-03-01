//
//  DownloadLeagueSessionsOperation.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

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
    }
}
