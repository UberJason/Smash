//
//  ViewController.swift
//  Smash
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import SmashKit
import SmashUIKit
import SwiftSoup

class FauxModel {
    
    init() {
        
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    let preferredPlayer = Player(name: "Jason Ji")
    var session: LeagueSession?
    var matches: [Match]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: Nibs.matchResultCell, bundle: Bundle(for: MatchResultCell.self)), forCellReuseIdentifier: CellIdentifiers.matchResultCell)
        
        let url = URL(string: "http://www.tabletennisleague.com/SmashTT/SessionGroupReportArchive/SessionGroupReport2018February23.HTM")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let html = String(data: data, encoding: .utf8)
                DispatchQueue.main.async {
                    let parser = try! Parser(html: html)
                    
                    try! parser.parseGameTables(leagueSession: &self.session)
                    self.matches = self.session?.group(for: self.preferredPlayer)?.matches.filter { $0.contains(player: self.preferredPlayer) }
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let match = matches?[indexPath.row] else { fatalError("No match") }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.matchResultCell, for: indexPath) as! MatchResultCell
        cell.configure(with: match, preferredPlayer: preferredPlayer)
        return cell
    }
}
