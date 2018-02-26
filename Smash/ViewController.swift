//
//  ViewController.swift
//  Smash
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import SmashKit
import SwiftSoup

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let parser = SmashKit.Parser()
        
        do {
            let url = URL(fileURLWithPath: Bundle.main.path(forResource: "SessionGroupReport", ofType: "html")!)
            let html = try! String(contentsOf: url)
            
            let doc: Document = try SwiftSoup.parse(html)
            
            let results = try parser.parseGameTables(doc)
            print(results[2].matches)
            
        } catch Exception.Error(let type, let message) {
            print(type)
            print(message)
        } catch {
            print("error")
        }
        
    }
}
