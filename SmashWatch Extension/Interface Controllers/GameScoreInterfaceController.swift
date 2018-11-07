//
//  ScoreInterfaceController.swift
//  SmashWatch Extension
//
//  Created by Jason Ji on 11/1/18.
//  Copyright © 2018 Jason Ji. All rights reserved.
//

import WatchKit
import SmashKitWatch

struct GameScoreModel {
    var gameNumber: Int
    var game: Game
    var player1Score: Int
    var player2Score: Int
}

protocol GameScoreDelegate: class {
    func didSaveGame(_ game: Game)
    func didDeleteGame(_ game: Game)
}

class GameScoreInterfaceController: WKInterfaceController {

    @IBOutlet weak var gameLabel: WKInterfaceLabel!
    
    @IBOutlet weak var player1NameLabel: WKInterfaceLabel!
    @IBOutlet weak var player2NameLabel: WKInterfaceLabel!
    
    @IBOutlet weak var player1ScorePicker: WKInterfacePicker!
    @IBOutlet weak var player2ScorePicker: WKInterfacePicker!
    
    @IBOutlet weak var saveGameButton: WKInterfaceButton!
    @IBOutlet weak var deleteGameButton: WKInterfaceButton!
    
    var model: GameScoreModel?
    var isNewGame: Bool = false
    
    weak var delegate: GameScoreDelegate?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        initializePickers()
        
        if let (number, game, delegate, isNew) = context as? (Int, Game, GameScoreDelegate, Bool) {
            self.isNewGame = isNew
            self.delegate = delegate
            model = GameScoreModel(gameNumber: number, game: game, player1Score: game.player1Score, player2Score: game.player2Score)
            
            gameLabel.setText("Game \(number)")
            player1NameLabel.setText(game.player1.firstName)
            player2NameLabel.setText(game.player2.firstName)
            
            player1ScorePicker.setSelectedItemIndex(max(game.player1Score, 0))
            player2ScorePicker.setSelectedItemIndex(max(game.player2Score, 0))
            
            deleteGameButton.setHidden(isNew)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func initializePickers() {
        player1ScorePicker.setItems(scorePickerItems())
        player2ScorePicker.setItems(scorePickerItems())
        
    }
    
    func scorePickerItems() -> [WKPickerItem] {
        return Array(0 ... 30).map { return WKPickerItem(title: "\($0)") }
    }
    
    @IBAction func changePlayer1Score(_ value: Int) {
        model?.player1Score = value
    }
    
    @IBAction func changePlayer2Score(_ value: Int) {
        model?.player2Score = value
    }
    
    @IBAction func saveGame() {
        guard let model = model else { return }
        model.game.player1Score = model.player1Score
        model.game.player2Score = model.player2Score
        delegate?.didSaveGame(model.game)
        if isNewGame {
            dismiss()
        }
        else {
            pop()
        }
    }
    
    @IBAction func deleteGame() {
        guard let game = model?.game else { return }
        delegate?.didDeleteGame(game)
        if isNewGame {
            dismiss()
        }
        else {
            pop()
        }
    }
    
}
