//
//  NewMatchInterfaceController.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit
import SmashKitWatch
import CoreData

struct Game {
    var player1: Player
    var player2: Player
    
    let player1Score: Int
    let player2Score: Int
    
    func outcomeDescription(for primaryPlayer: Player) -> String? {
        guard primaryPlayer == player1 || primaryPlayer == player2 else { return nil }
        if primaryPlayer == player1 {
            return "\(winner == player1 ? "W" : "L"), \(player1Score)-\(player2Score)"
        }
        else {
            return "\(winner == player2 ? "W" : "L"), \(player2Score)-\(player1Score)"
        }
    }
    
    var winner: Player {
        return player1Score > player2Score ? player1 : player2
    }
}

class NewMatchModel {
    private var games = [Game]()
    private let primaryPlayer: Player
    
    init(primaryPlayer: Player) {
        self.primaryPlayer = primaryPlayer
    }
    
    var numberOfGames: Int {
        return games.count
    }
    
    func game(at index: Int) -> Game? {
        guard index < games.count else { return nil }
        return games[index]
    }
    
    func addGame(_ game: Game) {
        games.append(game)
    }
    
    func delete(at index: Int) {
        games.remove(at: index)
    }
    
    var summaryDescription: String {
        let wins = games.filter { $0.winner == primaryPlayer }.count
        let losses = games.filter { $0.winner != primaryPlayer }.count
        
        let net = wins - losses
        switch net {
        case _ where net > 0:
            return "W, \(wins)-\(losses)"
        case _ where net == 0:
            return "T, \(wins)-\(losses)"
        case _ where net < 0:
            return "L, \(wins)-\(losses)"
        default: fatalError("Impossible arithmetic?")
        }
    }
}

class NewMatchInterfaceController: WKInterfaceController {

    @IBOutlet weak var summaryLabel: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    
    var model: NewMatchModel?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // DEBUG
        
        let player1 = try! Player.newOrExistingPlayer(name: "Jason Ji", managedObjectContext: SmashStackManager.shared.managedObjectContext)
        let player2 = try! Player.newOrExistingPlayer(name: "Kevin Ji", managedObjectContext: SmashStackManager.shared.managedObjectContext)
    
        model = NewMatchModel(primaryPlayer: player1)
        
        model?.addGame(Game(player1: player1, player2: player2, player1Score: 11, player2Score: 7))
        model?.addGame(Game(player1: player1, player2: player2, player1Score: 11, player2Score: 9))
        model?.addGame(Game(player1: player1, player2: player2, player1Score: 10, player2Score: 12))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        configureGameTable()
        configureSummaryLabel()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func configureGameTable() {
        guard let model = model else { return }
        
        table.setNumberOfRows(model.numberOfGames, withRowType: "gameRow")
        for i in 0..<model.numberOfGames {
            guard let game = model.game(at: i) else { return }
            guard let row = table.rowController(at: i) as? GameRowController else { return }
            row.configure(with: game, number: i + 1, primaryPlayer: game.player1)
        }
    }
    
    func configureSummaryLabel() {
        guard let model = model else { return }
        summaryLabel.setText(model.summaryDescription)
    }
    
}
