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
    
    init(session: LeagueSession, player: Player?, managedObjectContext: NSManagedObjectContext) {
        self.session = session
        self.player = player
        self.managedObjectContext = managedObjectContext
        
        if let player = self.player {
            self.groupResult = session.group(for: player)
            self.matches = groupResult?.matches(for: player)
        }
    }
    
    convenience init(session: LeagueSession, playerName: String, managedObjectContext: NSManagedObjectContext) {
        
        let player = { () -> Player? in
            let fetchRequest: NSFetchRequest<Player> = Player.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "nameCD == %@", playerName)
            return try! managedObjectContext.fetch(fetchRequest).first
        }()
    
        self.init(session: session, player: player, managedObjectContext: managedObjectContext)
    }
}

class PlayerSessionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playerDetailsView: PlayerDetailsView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(refreshSessionDetails(_:)), for: .valueChanged)
        return r
    }()

    var model: PlayerSessionDetailsModel?

    // TODO: refactor this - currently if you set session directly, it'll use saved preferredPlayer, and if you call setPlayer(_:session:) it will set the passed Player. Make this better.
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
    
    func setPlayer(_ player: Player, session: LeagueSession) {
        if let date = session.date {
            title = Parser.sessionLongDateFormatter.string(from: date)
            model = PlayerSessionDetailsModel(session: session, player: player, managedObjectContext: SmashStackManager.shared.managedObjectContext)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Nibs.matchResultCell, bundle: Bundle(for: MatchResultCell.self)), forCellReuseIdentifier: CellIdentifiers.matchResultCell)
        
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        
        playerDetailsView.configure(with: model?.groupResult, player: model?.player)
        
        if let model = model, !model.session.containsResults {
            playerDetailsView.alpha = 0.0
            tableView.alpha = 0.0
            refreshSessionDetails()
            spinnerView.startAnimating()
        }
    }
    
    @objc func refreshSessionDetails(_ refreshControl: UIRefreshControl? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.sharedInstance.fetchLeagueSessionDetails(model?.session) { (session) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.session = session
            self.playerDetailsView.alpha = 1.0
            self.tableView.alpha = 1.0
            self.playerDetailsView.configure(with: self.model?.groupResult, player: self.model?.player)
            self.spinnerView.stopAnimating()
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let model = model, let _ = model.groupResult, let _ = model.session.numberOfGroups else { return 0 }
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = model, let groupResult = model.groupResult, let numberOfGroups = model.session.numberOfGroups else {
            return nil
        }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35.0))
        
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Group \(groupResult.groupNumber) of \(numberOfGroups)"
        
        let dividerLine = UIView(frame: CGRect(x: 0, y: 34.5, width: tableView.frame.width, height: 0.5))
        dividerLine.backgroundColor = UIColor.dividerGray
        label.addSubview(dividerLine)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let match = model?.matches?[indexPath.row], let player = model?.player else { fatalError("No match or preferred Player") }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.matchResultCell, for: indexPath) as! MatchResultCell
        cell.configure(with: match, preferredPlayer: player)
        return cell
    }
}
