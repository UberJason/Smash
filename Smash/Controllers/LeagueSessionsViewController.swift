//
//  LeagueSessionsViewController.swift
//  Smash
//
//  Created by Jason Ji on 3/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import UIKit
import CoreData
import SmashKit
import SmashUIKit

class LeagueSessionsViewController: UIViewController {

    lazy var leagueSessions: [LeagueSession]? = SmashStackManager.shared.allLeagueSessions()

    @IBOutlet weak var tableView: UITableView!
    private lazy var refreshControl: UIRefreshControl = {
        let r = UIRefreshControl()
        r.addTarget(self, action: #selector(refreshSessions(_:)), for: .valueChanged)
        return r
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.refreshControl = refreshControl
        refreshSessions()
    }
    
    @objc func refreshSessions(_ refreshControl: UIRefreshControl? = nil) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NetworkController.sharedInstance.fetchLeagueSessions {
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.leagueSessions = SmashStackManager.shared.allLeagueSessions()
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
        }
    }
}

extension LeagueSessionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagueSessions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let leagueSessions = leagueSessions else { fatalError("No league sessions for this tableView") }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.leagueSessionCell, for: indexPath) as! LeagueSessionCell
        cell.configure(with: leagueSessions[indexPath.row])
        return cell
    }
}
