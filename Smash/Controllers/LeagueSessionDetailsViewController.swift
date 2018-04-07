//
//  LeagueSessionDetailsViewController.swift
//  Smash
//
//  Created by Jason Ji on 4/6/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import CoreData
import SmashKit
import SmashUIKit

class LeagueSessionDetailsModel {
    var session: LeagueSession
    var groupResults: [GroupResult]?
    var managedObjectContext: NSManagedObjectContext
    
    init(session: LeagueSession, managedObjectContext: NSManagedObjectContext) {
        self.session = session
        self.groupResults = session.groupResults?.sorted { $0.groupNumber < $1.groupNumber }
        self.managedObjectContext = managedObjectContext
    }
    
    func numberOfGroups() -> Int {
        return session.numberOfGroups ?? 0
    }
    
    func numberOfPlayers(in group: Int) -> Int {
        guard let groupResults = groupResults, group < groupResults.count else { return 0 }
        return groupResults[group].players.count
    }
    
    func groupResult(at index: Int) -> GroupResult? {
        guard let groupResults = groupResults, index < groupResults.count else { return nil }
        return groupResults[index]
    }
    
    func group(_ group: Int, playerAtIndex index: Int) -> (GroupResult?, Player?) {
        guard let groupResult = groupResult(at: group) else { return (nil, nil) }
        
        guard index < groupResult.players.count else { return (nil, nil) }
        let player = groupResult.players[index]
        
        return (groupResult, player)
    }
}

class LeagueSessionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinnerView: UIActivityIndicatorView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(refreshSessionDetails(_:)), for: .valueChanged)
        return r
    }()
    
    var model: LeagueSessionDetailsModel?
    
    var session: LeagueSession? {
        get { return nil }
        set {
            if let newValue = newValue, let date = newValue.date {
                title = Parser.sessionLongDateFormatter.string(from: date)
                model = LeagueSessionDetailsModel(session: newValue, managedObjectContext: SmashStackManager.shared.managedObjectContext)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: Nibs.playerResultCell, bundle: Bundle(for: PlayerResultCell.self)), forCellReuseIdentifier: CellIdentifiers.playerResultCell)
        
        tableView.refreshControl = refreshControl
        tableView.tableFooterView = UIView()
        
        if let model = model, !model.session.containsResults {
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
            self.tableView.alpha = 1.0
            self.spinnerView.stopAnimating()
            self.tableView.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let model = model,
            segue.identifier == Segues.playerDetails,
            let player = sender as? Player,
            let destination = segue.destination as? PlayerSessionDetailsViewController else { return }
        
        destination.setPlayer(player, session: model.session)
    }
}

extension LeagueSessionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model?.numberOfGroups() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.numberOfPlayers(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let model = model, let groupResult = model.groupResult(at: section) else { return nil }
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35.0))
        
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.text = "Group \(groupResult.groupNumber) of \(model.numberOfGroups())"
        
        let dividerLine = UIView(frame: CGRect(x: 0, y: 34.5, width: tableView.frame.width, height: 0.5))
        dividerLine.backgroundColor = UIColor.dividerGray
        label.addSubview(dividerLine)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (groupResult, player) = model?.group(indexPath.section, playerAtIndex: indexPath.row) else { fatalError("No Group Result or Player") }
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.playerResultCell, for: indexPath) as! PlayerResultCell
        cell.configure(with: groupResult, player: player)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let player = model?.group(indexPath.section, playerAtIndex: indexPath.row) else { return }
        performSegue(withIdentifier: "playerDetailsSegue", sender: player)
    }
}
