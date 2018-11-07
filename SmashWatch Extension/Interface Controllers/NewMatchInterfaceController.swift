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

class NewMatchModel {
    var match: ScorekeepingMatch

    public var primaryPlayer: Player { return match.player1 }
    public var opponent: Player { return match.player2 }
    
    init(match: ScorekeepingMatch) {
        self.match = match
    }
    
    var numberOfGames: Int {
        return match.games.count
    }
    
    func game(at index: Int) -> Game? {
        guard index < match.games.count else { return nil }
        return match.games[index]
    }
    
    func addGame(_ game: Game) {
        if !match.games.contains(game) {
            match.games.append(game)
        }
    }
    
    func delete(at index: Int) {
        match.games.remove(at: index)
    }
    
    func delete(_ game: Game) {
        if let index = match.games.firstIndex(where: { $0 == game }) {
            delete(at: index)
        }
    }
    
    var summaryDescription: String {
        return match.summaryDescription(for: primaryPlayer)
    }
    
}

protocol MatchDetailDelegate: class {
    func didSaveMatch(_ match: ScorekeepingMatch)
    func didDeleteMatch(_ match: ScorekeepingMatch)
}

class NewMatchInterfaceController: WKInterfaceController {

    @IBOutlet weak var matchLabel: WKInterfaceLabel!
    @IBOutlet weak var summaryLabel: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    
    @IBOutlet weak var saveMatchButton: WKInterfaceButton!
    @IBOutlet weak var deleteMatchButton: WKInterfaceButton!
    
    var model: NewMatchModel?
    weak var delegate: MatchDetailDelegate?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if let (number, match, delegate) = context as? (Int, ScorekeepingMatch, MatchDetailDelegate) {
            self.delegate = delegate
            model = NewMatchModel(match: match)
            if match.games.count == 0 {
                deleteMatchButton.setHidden(true)
                saveMatchButton.setHidden(false)
            }
            else {
                deleteMatchButton.setHidden(false)
                saveMatchButton.setHidden(true)
            }
            
            matchLabel.setText("Match #\(number)")
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        guard let model = model else { return nil }
        let newGame = Game(player1: model.primaryPlayer, player2: model.opponent, player1Score: 0, player2Score: 0)
        return (model.numberOfGames + 1, newGame, self as GameScoreDelegate, true)
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        guard let model = model else { return nil }
        let game = model.game(at: rowIndex)
        return (rowIndex + 1, game, self as GameScoreDelegate, false)
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
    
    @IBAction func saveMatch() {
        guard let match = model?.match else { return }
        delegate?.didSaveMatch(match)
    }
    
    @IBAction func deleteMatch() {
        guard let match = model?.match else { return }
        delegate?.didDeleteMatch(match)
    }
}

extension NewMatchInterfaceController: GameScoreDelegate {
    func didSaveGame(_ game: Game) {
        model?.addGame(game)
    }
    
    func didDeleteGame(_ game: Game) {
        model?.delete(game)
    }
}
