//
//  DownloadSessionDetailsOperation.swift
//  SmashKit
//
//  Created by Jason Ji on 2/28/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import Foundation

protocol DownloadSessionDetailsOperationDelegate: class {
    func leagueSessionDetailsDownloaded(_ html: String)
}

class DownloadSessionDetailsOperation: Operation {
    weak var delegate: DownloadSessionDetailsOperationDelegate?
    let sessionDownloadURL: URL
    
    init(sessionDownloadURL: URL) {
        self.sessionDownloadURL = sessionDownloadURL
    }
    
    override func main() {
        let semaphore = DispatchSemaphore(value: 0)
        
        let task = URLSession.shared.dataTask(with: sessionDownloadURL) { (data, response, error) in
            if let data = data {
                let html = String(data: data, encoding: .utf8)!
                self.delegate?.leagueSessionDetailsDownloaded(html)
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
