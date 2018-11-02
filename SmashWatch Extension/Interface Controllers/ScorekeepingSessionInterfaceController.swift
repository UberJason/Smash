//
//  ScorekeepingSessionInterfaceController.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/2/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit
import SmashKitWatch
import CoreData

class ScorekeepingSessionModel {
    private var session: ScorekeepingSession
    
    init(session: ScorekeepingSession) {
        self.session = session
    }
    
    var numberOfMatches: Int {
        return session.matches.count
    }
    
    func match(at index: Int) -> ScorekeepingMatch? {
        guard index < session.matches.count else { return nil }
        return session.matches[index]
    }
    
    func addMatch(_ match: ScorekeepingMatch) {
        if !session.matches.contains(match) {
            session.matches.append(match)
        }
    }
    
    func delete(at index: Int) {
        session.matches.remove(at: index)
    }
}

class ScorekeepingSessionInterfaceController: WKInterfaceController {

    @IBOutlet weak var sessionLabel: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    
    var model: ScorekeepingSessionModel?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // DEBUG
        
        let player1 = try! Player.newOrExistingPlayer(name: "Jason Ji", managedObjectContext: SmashStackManager.shared.managedObjectContext)
        let player2 = try! Player.newOrExistingPlayer(name: "Kevin Ji", managedObjectContext: SmashStackManager.shared.managedObjectContext)
        
        
        model = ScorekeepingSessionModel(session: ScorekeepingSession(date: Date()))
        
        model?.addMatch(ScorekeepingMatch(player1: player1, player2: player2, games: [
            Game(player1: player1, player2: player2, player1Score: 11, player2Score: 8),
            Game(player1: player1, player2: player2, player1Score: 11, player2Score: 7),
            Game(player1: player1, player2: player2, player1Score: 5, player2Score: 11),
            Game(player1: player1, player2: player2, player1Score: 12, player2Score: 14),
            Game(player1: player1, player2: player2, player1Score: 11, player2Score: 9)
            ]))
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        
        let player1 = try! Player.newOrExistingPlayer(name: "Jason Ji", managedObjectContext: SmashStackManager.shared.managedObjectContext)
        let player2 = try! Player.newOrExistingPlayer(name: "Opponent", managedObjectContext: SmashStackManager.shared.managedObjectContext)
        
        guard let model = model else { return nil }
        let newMatch = ScorekeepingMatch(player1: player1, player2: player2)
        return (model.numberOfMatches + 1, newMatch, self as MatchDetailDelegate)
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        guard let model = model else { return nil }
        let match = model.match(at: rowIndex)
        return (rowIndex + 1, match, self as MatchDetailDelegate)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        configureMatchTable()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func configureMatchTable() {
        guard let model = model else { return }
        
        table.setNumberOfRows(model.numberOfMatches, withRowType: "matchRow")
        for i in 0..<model.numberOfMatches {
            guard let match = model.match(at: i) else { return }
            guard let row = table.rowController(at: i) as? MatchRowController else { return }
            row.configure(with: match, number: i + 1, primaryPlayer: match.player1)
        }
    }
}

extension ScorekeepingSessionInterfaceController: MatchDetailDelegate {
    func didSaveMatch(_ match: ScorekeepingMatch) {
        model?.addMatch(match)
        pop()
    }
}
