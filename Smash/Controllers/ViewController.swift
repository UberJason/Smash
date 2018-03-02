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
        fetchRequest.predicate = NSPredicate(format: "nameCD == %@", UserDefaults.standard.preferredPlayer!)
        return try! SmashStackManager.shared.managedObjectContext.fetch(fetchRequest).first!
    }()
    var session: LeagueSession?
    var matches: [Match]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.register(UINib(nibName: Nibs.matchResultCell, bundle: Bundle(for: MatchResultCell.self)), forCellReuseIdentifier: CellIdentifiers.matchResultCell)
      
        let session = check()
        self.matches = session?.group(for: self.preferredPlayer)?.matches.filter { $0.contains(player: self.preferredPlayer) }
        tableView.reloadData()

        NetworkController.sharedInstance.fetchLeagueSessions { (sessions) in
            NetworkController.sharedInstance.fetchLeagueSessionDetails(sessions.first!, completionHandler: { (session) in
                self.matches = session?.group(for: self.preferredPlayer)?.matches.filter { $0.contains(player: self.preferredPlayer) }
                self.tableView.reloadData()
            })
        }

    }
    
    func check() -> LeagueSession? {
        let fetchRequest: NSFetchRequest<LeagueSession> = LeagueSession.fetchRequest()
        let sessions = try! SmashStackManager.shared.managedObjectContext.fetch(fetchRequest).sorted { $0.date! > $1.date! }
        print("sessions count: \(sessions.count)")
        let session = sessions.first
        print("group results: \(session?.groupResults)")
        return session
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
