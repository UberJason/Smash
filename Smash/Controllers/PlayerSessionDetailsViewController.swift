//
//  PlayerSessionDetailsViewController.swift
//  Smash
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import CoreData
import SmashKit
import SmashUIKit

class PlayerSessionDetailsModel {
    var session: LeagueSession
    
    var player: Player?
    var groupResult: GroupResult?
    var matches: [Match]?
    var managedObjectContext: NSManagedObjectContext
    
    init(session: LeagueSession, playerName: String, managedObjectContext: NSManagedObjectContext) {
        self.session = session
        self.managedObjectContext = managedObjectContext
        self.player = { () -> Player? in
            let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "nameCD == %@", playerName)
            return try! managedObjectContext.fetch(fetchRequest).first
        }()
    
        if let player = self.player {
            self.groupResult = session.group(for: player)
            self.matches = groupResult?.matches(for: player)
        }
    }
    
    
}

class PlayerSessionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerDetailsView: PlayerDetailsView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(refreshSessionDetails(_:)), for: .valueChanged)
        return r
    }()
    

    var model: PlayerSessionDetailsModel?
    
    var session: LeagueSession? {
        get {
            return nil
        }
        set {
            if let newValue = newValue, let date = newValue.date {
                title = Parser.sessionLongDateFormatter.string(from: date)
                
                model = PlayerSessionDetailsModel(session: newValue, playerName: UserDefaults.standard.preferredPlayer ?? "", managedObjectContext: SmashStackManager.shared.managedObjectContext)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Nibs.matchResultCell, bundle: Bundle(for: MatchResultCell.self)), forCellReuseIdentifier: CellIdentifiers.matchResultCell)
        
        tableView.refreshControl = refreshControl
        
        playerDetailsView.configure(with: model?.groupResult, player: model?.player)
        
        if let model = model, !model.session.containsResults {
            playerDetailsView.alpha = 0.0
            refreshSessionDetails()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @objc func refreshSessionDetails(_ refreshControl: UIRefreshControl? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.sharedInstance.fetchLeagueSessionDetails(model?.session) { (session) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.session = session
            self.playerDetailsView.alpha = 1.0
            self.playerDetailsView.configure(with: self.model?.groupResult, player: self.model?.player)
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
}

extension PlayerSessionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.matches?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let match = model?.matches?[indexPath.row], let player = model?.player else { fatalError("No match or preferred Player") }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.matchResultCell, for: indexPath) as! MatchResultCell
        cell.configure(with: match, preferredPlayer: player)
        return cell
    }
}

