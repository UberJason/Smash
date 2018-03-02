//
//  ViewController.swift
//  Smash
//
//  Created by Jason Ji on 2/23/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import CoreData
import SmashKit
import SmashUIKit
import SwiftSoup

class FauxModel {
    
    init() {
        
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var preferredPlayer: Player = {
        let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
        return try! SmashStackManager.shared.managedObjectContext.fetch(fetchRequest).first!
    }()
    var session: LeagueSession?
    var matches: [Match]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: Nibs.matchResultCell, bundle: Bundle(for: MatchResultCell.self)), forCellReuseIdentifier: CellIdentifiers.matchResultCell)
        
        
        // 1. No GroupResults - fetch them, ensure saved
        // 2. With GroupResults - ensure saved, fetch them, ensure no duplicates
        
        NetworkController.sharedInstance.fetchLeagueSessions { (sessions) in
            NetworkController.sharedInstance.fetchLeagueSessionDetails(sessions.first!, completionHandler: { (session) in
                for result in session!.groupResults! {
//                    print(result)
                }
                
                let allResults = try! SmashStackManager.shared.managedObjectContext.fetch(GroupResult.fetchRequest())
                print(allResults.count)
            })
        }
        
        
        
        
        
        
        
//                DispatchQueue.main.async {
//                    let parser = try! Parser(html: html)
//
//                    try! parser.parseGameTables(leagueSession: &self.session)
//                    self.matches = self.session?.group(for: self.preferredPlayer)?.matches.filter { $0.contains(player: self.preferredPlayer) }
//                    self.tableView.reloadData()
//                }
        
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
