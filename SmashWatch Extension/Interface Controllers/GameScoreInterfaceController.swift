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
    
    weak var delegate: GameScoreDelegate?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        initializePickers()
        
        if let (number, game, delegate) = context as? (Int, Game, GameScoreDelegate) {
            self.delegate = delegate
            model = GameScoreModel(gameNumber: number, game: game)
            
            gameLabel.setText("Game \(number)")
            player1NameLabel.setText(game.player1.firstName)
            player2NameLabel.setText(game.player2.firstName)
            
            player1ScorePicker.setSelectedItemIndex(max(game.player1Score - 1, 0))
            player2ScorePicker.setSelectedItemIndex(max(game.player2Score - 1, 0))
            
            if game.player1Score == 0 && game.player2Score == 0 {
                deleteGameButton.setHidden(true)
                saveGameButton.setHidden(false)
            }
            else {
                deleteGameButton.setHidden(false)
                saveGameButton.setHidden(true)
            }
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
        return Array(1 ... 30).map { return WKPickerItem(title: "\($0)") }
    }
    
    @IBAction func changePlayer1Score(_ value: Int) {
        model?.game.player1Score = value + 1
    }
    
    @IBAction func changePlayer2Score(_ value: Int) {
        model?.game.player2Score = value + 1
    }
    
    @IBAction func saveGame() {
        guard let game = model?.game else { return }
        delegate?.didSaveGame(game)
    }
    
    @IBAction func deleteGame() {
        guard let game = model?.game else { return }
        delegate?.didDeleteGame(game)
    }
    
}
