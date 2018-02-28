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
    
        tableView.register(UINib(nibName: "MatchResultCell", bundle: Bundle(for: MatchResultCell.self)), forCellReuseIdentifier: "matchResultCell")
        
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "SessionGroupReport", ofType: "html")!)
        let html = try! String(contentsOf: url)
        let parser = Parser()
        let doc: Document = try! SwiftSoup.parse(html)
        
        session = try! parser.parseGameTables(doc)
        matches = session?.group(for: preferredPlayer)?.matches.filter { $0.contains(player: preferredPlayer) }
        tableView.reloadData()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchResultCell", for: indexPath) as! MatchResultCell
        cell.configure(with: match, preferredPlayer: preferredPlayer)
        return cell
    }
}

extension Match {
    var upperFont: UIFont {
        return winner == player1 ? UIFont.systemFont(ofSize: 17.0, weight: .semibold) : UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    var lowerFont: UIFont {
        return winner == player2 ? UIFont.systemFont(ofSize: 17.0, weight: .semibold) : UIFont.systemFont(ofSize: 17.0, weight: .regular)
    }
    
    var upperTextColor: UIColor {
        return winner == player1 ? UIColor.black : UIColor.defeatGray
    }
    
    var lowerTextColor: UIColor {
        return winner == player2 ? UIColor.black : UIColor.defeatGray
    }

    func ratingChangeString(for player: Player) -> String? {
        guard contains(player: player) else { return nil }
        if player1 == player {
            return p1RatingChange >= 0 ? "+\(p1RatingChange)" : "–\(-1*p1RatingChange)"
        }
        else {
            return p2RatingChange >= 0 ? "+\(p2RatingChange)" : "–\(-1*p2RatingChange)"
        }
    }
    
    func ratingChangeColor(for player: Player) -> UIColor? {
        guard contains(player: player) else { return nil }
        
        return winner == player ? .victoryGreen : .defeatRed
    }
    
    var matchArrowStyle: MatchArrowStyle {
        return player1 == winner ? .upperArrow : .lowerArrow
    }
}

extension MatchResultCell {
    func configure(with match: Match, preferredPlayer player: Player) {
        guard let ratingChangeString = match.ratingChangeString(for: player),
            let ratingChangeColor = match.ratingChangeColor(for: player)
            else { fatalError("This match doesn't contain this player, what are you doing??") }
        
        let params = MatchResultCellParams(upperPlayerName: match.player1.name,
                                           lowerPlayerName: match.player2.name,
                                           upperScore: match.player1Wins,
                                           lowerScore: match.player2Wins,
                                           upperFont: match.upperFont,
                                           lowerFont: match.lowerFont,
                                           upperTextColor: match.upperTextColor,
                                           lowerTextColor: match.lowerTextColor,
                                           ratingChangeString: ratingChangeString,
                                           ratingChangeColor: ratingChangeColor,
                                           matchResultStyle: match.matchArrowStyle)
        
        configure(with: params)
    }
}
